//+------------------------------------------------------------------+
//|                                               ilan_trio_v147.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                              Ilan-Trio V1.47.mq4 |
//|                                                            Night |
//|                                        http://alfonius@yandex.ru |
//+------------------------------------------------------------------+
// Dec 15 -2011 -- Add Timer for Loop and print to screen
// Sep 12 - 2016 -- exposed time frame for ilan1.5
extern string t1 = "General Settings";
extern bool DisplayOnScreenText = true;
extern double Lots = 0.10;          // Initial lot
extern double LotExponent = 1.85;   // Exponent at which next trade will multiply
extern int    lotdecimal = 2;       // 2 - microlot 0.01, 1 - mini lot 0.1, 0 - standard lot 1.0
extern double PipStep = 50.0;       // At what distance should next trade be taken
extern bool   Turbo = false;         // First 3 trades will be closer together
extern bool   MarioTurbo = true;    // Mario's adaptive turbo, fast in begining slower in the end
extern int    MarioTurboFactor = 5; // 
extern bool   NewCycle = true;      // Start new cycles (running will continue to run)
extern int    PeriodRSI = 5;        // 1=M1, 2=M5, 3=M15, 4=M30, 5=H1, 6=H4, 7=D1, 8=W1, 9=MN1, 0=Current chart
int PerRSI;                         // Период RSI
double MaxLots = 10;                // Max allowed lot as start
extern bool   MM =FALSE;            // MM - money management
extern double TakeProfit = 100.0;    // points to take profit (average price plus/minus this value)
bool UseEquityStop = FALSE;         // Use equity stop
double TotalEquityRisk = 20.0;      // Max allowed equity risk (trades will close at this level)
bool UseTrailingStop = FALSE;       // Use traling stop
double TrailStart = 100.0;           // Trailing start
double TrailStop = 10.0;             //Trailing stop
double slip = 5.0;                  // Slippage

//====================================================
//====================================================
//extern string t2 = "работа советника в пятницу- до и в понедельник- после";
//extern bool CloseFriday=true;     // использовать ограничение по времени в пятницу true, не использовать false
//extern int CloseFridayHour=17;    // время в пятницу после которого не выставляется первый ордер
//extern bool OpenMondey=true;      // использовать ограничение по времени в пятницу true, не использовать false
//extern int OpenMondeyHour=10;     // время в пятницу после которого не выставляется первый ордер

//=====================================================
//=====================================================

//===================================================================
//===================================================================
//-------------------Hilo_RSI--------------------------------------//
//===================================================================
extern string t3 = "Settings EA Ilan_Hilo";
double Lots_Hilo;                       // задание всех лотов через 1 переменную
int OnScreenDelay = 0;
double LotExponent_Hilo;       
int lotdecimal_Hilo, ord_Hilo;            
double TakeProfit_Hilo;                 // тейк профит
extern int MaxTrades_Hilo = 10;         // максимально количество одновременно открытых ордеров
bool UseEquityStop_Hilo;                // использовать риск в процентах
double TotalEquityRisk_Hilo;            // риск в процентах от депозита
//=====================================================
bool UseTimeOut_Hilo = FALSE;           // использовать анулирование ордеров по времени
double MaxTradeOpenHours_Hilo = 48.0;   // через колько часов анулировать висячие ордера
//=====================================================
bool UseTrailingStop_Hilo;              // использовать трейлинг стоп
extern double Stoploss_Hilo = 500.0;           // Эти параметра работают!!!
double TrailStart_Hilo;
double TrailStop_Hilo;
//=====================================================
double PipStep_Hilo;                    // шаг колена- был 30
double slip_Hilo;                       // проскальзывание
extern int MagicNumber_Hilo = 11111;    // магик
//=====================================================
double PriceTarget_Hilo, StartEquity_Hilo, BuyTarget_Hilo, SellTarget_Hilo, Balans, Sredstva ;
double AveragePrice_Hilo, SellLimit_Hilo, BuyLimit_Hilo ;
double LastBuyPrice_Hilo, LastSellPrice_Hilo, Spread_Hilo;
bool flag_Hilo;
string EAName_Hilo = "Ilan_HiLo_RSI";
int timeprev_Hilo = 0, expiration_Hilo;
int NumOfTrades_Hilo = 0;
double iLots_Hilo;
int cnt_Hilo = 0, total_Hilo;
double Stopper_Hilo = 0.0;
bool TradeNow_Hilo = FALSE, LongTrade_Hilo = FALSE, ShortTrade_Hilo = FALSE;
int ticket_Hilo;
bool NewOrdersPlaced_Hilo = FALSE;
double AccountEquityHighAmt_Hilo, PrevEquity_Hilo;
//==============================
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//            ILAN 1.5                       //
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extern string t4 = "Settings EA Ilan 1.5";
double LotExponent_15;
double Lots_15;
int lotdecimal_15, ord_15;
double TakeProfit_15;
bool UseEquityStop_15;                   // использовать риск в процентах
double TotalEquityRisk_15;               // риск в процентах от депозита
extern int MaxTrades_15 = 10;
extern int OpenNewTF_15 = 60;            //When should 1.5 activate. Default is every 60 minutes, unless trades are already running
extern int TimeFrameCloseValue = 0; //What time fram to use for comparing close value. 1=M1, 2=M5, 3=M15, 4=M30, 5=H1, 6=H4, 7=D1, 8=W1, 9=MN1, 0=Current chart
int gi_unused_88_15;
//==============================================
bool UseTrailingStop_15;                 // использовать трейлинг стоп
extern double Stoploss_15 = 500.0;              // Эти параметры  не работают!!!
double TrailStart_15;
double TrailStop_15;
//==============================================
bool UseTimeOut_15 = FALSE;              // использовать анулирование ордеров по времени
double MaxTradeOpenHours_15 = 48.0;      // через колько часов анулировать висячие ордера
//===============================================
double PipStep_15; //30
double slip_15;
extern int g_magic_176_15 = 12324;
//===============================================
double g_price_180_15;
double gd_188_15;
double gd_unused_196_15;
double gd_unused_204_15;
double g_price_212_15;
double g_bid_220_15;
double g_ask_228_15;
double gd_236_15;
double gd_244_15;
double Spread_15;
bool gi_268_15;
string gs_ilan_272_15 = "Ilan 1.5";
int gi_280_15 = 0;
int gi_284_15;
int gi_288_15 = 0;
double gd_292_15;
int g_pos_300_15 = 0;
int gi_304_15;
double gd_308_15 = 0.0;
bool gi_316_15 = FALSE;
bool gi_320_15 = FALSE;
bool gi_324_15 = FALSE;
int gi_328_15;
bool gi_332_15 = FALSE;
double gd_336_15;
double gd_344_15;
datetime time_15=1;
//========================================================================
//                 ILAN 1.6                                             //
//========================================================================
extern string t5 = "Settings EA Ilan 1.6";
double LotExponent_16;
double Lots_16;
int lotdecimal_16, ord_16;
double TakeProfit_16;
extern int MaxTrades_16 = 10;
bool UseEquityStop_16;                    // использовать риск в процентах
double TotalEquityRisk_16;                // риск в процентах от депозита
int OpenNewTF_16 = 1;
//=========================================================
bool UseTrailingStop_16;
extern double Stoploss_16 = 500.0;               // Эти три параметра не работают!!!
double TrailStart_16;
double TrailStop_16;
//=========================================================
bool UseTimeOut_16 = FALSE;
double MaxTradeOpenHours_16 = 48.0;
//=========================================================
double PipStep_16;//30
double slip_16;
extern int g_magic_176_16 = 16794;
//=========================================================
double g_price_180_16;
double gd_188_16;
double gd_unused_196_16;
double gd_unused_204_16;
double g_price_212_16;
double g_bid_220_16;
double g_ask_228_16;
double gd_236_16;
double gd_244_16;
double Spread_16;
bool gi_268_16;
string gs_ilan_272_16 = "Ilan 1.6";
int gi_280_16 = 0;
int gi_284_16;
int gi_288_16 = 0;
double gd_292_16;
int g_pos_300_16 = 0;
int gi_304_16;
double gd_308_16 = 0.0;
bool gi_316_16 = FALSE;
bool gi_320_16 = FALSE;
bool gi_324_16 = FALSE;
int gi_328_16;
bool gi_332_16 = FALSE;
double gd_336_16;
double gd_344_16;
datetime time_16=1;

/*
//==============================
//индикатор
//==============================
double gd_308;
int g_timeframe_492 = PERIOD_M1;
int g_timeframe_496 = PERIOD_M5;
int g_timeframe_500 = PERIOD_M15;
int g_timeframe_504 = PERIOD_M30;
int g_timeframe_508 = PERIOD_H1;
int g_timeframe_512 = PERIOD_H4;
int g_timeframe_516 = PERIOD_D1;
//string gs_unused_520 = "<<<< Chart Position Settings >>>>>";
bool g_corner_528 = TRUE;
int gi_532 = 0;
int gi_536 = 10;
int g_window_540 = 0;
//string gs_unused_544 = " <<<< Comments Settings >>>>>>>>";
bool gi_552 = TRUE;
bool gi_556 = TRUE;
bool gi_560 = FALSE;
int g_color_564 = Gray;
int g_color_568 = Gray;
int g_color_572 = Gray;
int g_color_576 = DarkOrange;
int g_color_580 = DarkOrange;
int gi_584 = 65280;
int gi_588 = 17919;
int gi_592 = 65280;
int gi_596 = 17919;
//string gs_unused_600 = " <<<< Price Color Settings >>>>>>>>";
int gi_608 = 65280;
int gi_612 = 255;
int gi_616 = 42495;
//string gs_unused_620 = "<<<< MACD Settings >>>>>>>>>>>";
int g_period_628 = 8;
int g_period_632 = 17;
int g_period_636 = 9;
int g_applied_price_640 = PRICE_CLOSE;
//string gs_unused_644 = "<<<< MACD Colors >>>>>>>>>>>>>>>>>>";
int gi_652 = 65280;
int gi_656 = 4678655;
int gi_660 = 32768;
int gi_664 = 255;
string gs_unused_668 = "<<<< STR Indicator Settings >>>>>>>>>>>>>";
string gs_unused_676 = "<<<< RSI Settings >>>>>>>>>>>>>";
int g_period_684 = 9;
int g_applied_price_688 = PRICE_CLOSE;
string gs_unused_692 = "<<<< CCI Settings >>>>>>>>>>>>>>";
int g_period_700 = 13;
int g_applied_price_704 = PRICE_CLOSE;
string gs_unused_708 = "<<<< STOCH Settings >>>>>>>>>>>";
int g_period_716 = 5;
int g_period_720 = 3;
int g_slowing_724 = 3;
int g_ma_method_728 = MODE_EMA;
string gs_unused_732 = "<<<< STR Colors >>>>>>>>>>>>>>>>";
int gi_740 = 65280;
int gi_744 = 255;
int gi_748 = 42495;
string gs_unused_752 = "<<<< MA Settings >>>>>>>>>>>>>>";
int g_period_760 = 5;
int g_period_764 = 9;
int g_ma_method_768 = MODE_EMA;
int g_applied_price_772 = PRICE_CLOSE;
string gs_unused_776 = "<<<< MA Colors >>>>>>>>>>>>>>";
int gi_784 = 65280;
int gi_788 = 255;
bool gi_792;
bool gi_796;
string gs_800;
double gd_808;
double g_acc_number_816;
double g_str2dbl_824;
double g_str_len_832;
double gd_848;
double gd_856;
double g_period_864;
double g_period_872;
double g_period_880;
double gd_888;
double gd_896;
double gd_904;
double gd_912;
double g_shift_920;
double gd_928;
double gd_936;
double gd_960;
double gd_968;
int g_bool_976;
double gd_980;
bool g_bool_988;
int gi_992;
*/
//==============================
//==============================
string    txt,txt1;
string    txt2="";
string    txt3="";
color col = ForestGreen;
//---------------------------------------------------------
datetime lastcheck;
int  begin, end, max, current; 
//-------------------------------------------------------- Loop Speed variables
//==============================
int init() {
   Spread_Hilo = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   Spread_15   = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   Spread_16   = MarketInfo(Symbol(), MODE_SPREAD) * Point; 
   if (Turbo == true && MarioTurbo == true) {
      return (ERR_COMMON_ERROR);
   }
   return (0); 
}// end init
//==============================
int deinit() {
{
/*
//-----
   ObjectDelete("cja");
   ObjectDelete("Signalprice");
   ObjectDelete("SIG_BARS_TF1");
   ObjectDelete("SIG_BARS_TF2");
   ObjectDelete("SIG_BARS_TF3");
   ObjectDelete("SIG_BARS_TF4");
   ObjectDelete("SIG_BARS_TF5");
   ObjectDelete("SIG_BARS_TF6");
   ObjectDelete("SIG_BARS_TF7");
   ObjectDelete("SSignalMACD_TEXT");
   ObjectDelete("SSignalMACDM1");
   ObjectDelete("SSignalMACDM5");
   ObjectDelete("SSignalMACDM15");
   ObjectDelete("SSignalMACDM30");
   ObjectDelete("SSignalMACDH1");
   ObjectDelete("SSignalMACDH4");
   ObjectDelete("SSignalMACDD1");
   ObjectDelete("SSignalSTR_TEXT");
   ObjectDelete("SignalSTRM1");
   ObjectDelete("SignalSTRM5");
   ObjectDelete("SignalSTRM15");
   ObjectDelete("SignalSTRM30");
   ObjectDelete("SignalSTRH1");
   ObjectDelete("SignalSTRH4");
   ObjectDelete("SignalSTRD1");
   ObjectDelete("SignalEMA_TEXT");
   ObjectDelete("SignalEMAM1");
   ObjectDelete("SignalEMAM5");
   ObjectDelete("SignalEMAM15");
   ObjectDelete("SignalEMAM30");
   ObjectDelete("SignalEMAH1");
   ObjectDelete("SignalEMAH4");
   ObjectDelete("SignalEMAD1");
   ObjectDelete("SIG_DETAIL_1");
   ObjectDelete("SIG_DETAIL_2");
   ObjectDelete("SIG_DETAIL_3");
   ObjectDelete("SIG_DETAIL_4");
   ObjectDelete("SIG_DETAIL_5");
   ObjectDelete("SIG_DETAIL_6");
   ObjectDelete("SIG_DETAIL_7");
   ObjectDelete("SIG_DETAIL_8");
//----
*/
//----
 ObjectDelete("Lable");
 ObjectDelete("Lable1");
 ObjectDelete("Lable2");
 ObjectDelete("Lable3"); 
 ObjectDelete("pipHiLo"); 
 ObjectDelete("pip15"); 
 ObjectDelete("pip16"); 
//----
  }
   return (0);
}
//========================================================================
//========================================================================
int start()
 {
 begin=GetTickCount();
 
  
 
 int    counted_bars=IndicatorCounted();

 if (Lots > MaxLots) Lots = MaxLots; //ограничение лотов
 if (DisplayOnScreenText) {
    if (OnScreenDelay >= 100) {
       {
       Comment("" 
            + "\n" 
            
           // + "   LOOP Speed  ",end-begin, " --- ", max,
           // + "\n"
            
            + "Ilan-Trio V 1.47 mod 1" 
            + "\n" 
            + "________________________________"  
            + "\n" 
            
            + "Broker:         " + AccountCompany()
            + "\n"
            
            + "LOOP Speed  " + max
            + "\n"      
            
              
            + "________________________________"  
            + "\n" 
            + "Owner:             " + AccountName() 
            + "\n" 
            + "Acc number        " + AccountNumber()
            + "\n" 
            + "Acc currency  :   " + AccountCurrency()   
            + "\n"         
            + "_______________________________"
            + "\n"
            + "Open trades Ilan_Hilo: " + CountTrades_Hilo()
            + "\n"
            + "Open trades Ilan_1.5 : " + CountTrades_15()
            + "\n"
            + "Open trades Ilan_1.6 : " + CountTrades_16()
            + "\n"
            + "Total trades         : " + OrdersTotal()
            + "\n"
            + "Total lots           : " + DoubleToStr(CountTotalLots(), 2)
            + "\n"
            + "_______________________________"
            + "\n"           
            + "Balance              : " + DoubleToStr(AccountBalance(), 2)          
            + "\n" 
            + "Equity               : " + DoubleToStr(AccountEquity(), 2)
            + "\n"      
            + "Margin:            " + DoubleToStr(AccountMargin(), 2)
            + "\n" 
            + "Profit:            " + DoubleToStr(AccountProfit(), 2)
            + "\n"  
            + "_______________________________");
      }
        Balans = NormalizeDouble( AccountBalance(),2);
     Sredstva = NormalizeDouble(AccountEquity(),2);  
       if (Sredstva >= Balans/6*5) col = DodgerBlue; 
       if (Sredstva >= Balans/6*4 && Sredstva < Balans/6*5)col = DeepSkyBlue;
       if (Sredstva >= Balans/6*3 && Sredstva < Balans/6*4)col = Gold;
       if (Sredstva >= Balans/6*2 && Sredstva < Balans/6*3)col = OrangeRed;
       if (Sredstva >= Balans/6   && Sredstva < Balans/6*2)col = Crimson;
       if (Sredstva <  Balans/5                           )col = Red;
      //------------------------- 
      ObjectDelete("Lable2");
      ObjectCreate("Lable2",OBJ_LABEL,0,0,1.0);
      ObjectSet("Lable2", OBJPROP_CORNER, 3);
      ObjectSet("Lable2", OBJPROP_XDISTANCE, 153);
      ObjectSet("Lable2", OBJPROP_YDISTANCE, 31);
      txt2=(DoubleToStr(AccountBalance(), 2));
      ObjectSetText("Lable2","Balance     "+txt2+"",16,"Times New Roman",DodgerBlue);
      //-------------------------   
      ObjectDelete("Lable3");
      ObjectCreate("Lable3",OBJ_LABEL,0,0,1.0);
      ObjectSet("Lable3", OBJPROP_CORNER, 3);
      ObjectSet("Lable3", OBJPROP_XDISTANCE, 153);
      ObjectSet("Lable3", OBJPROP_YDISTANCE, 11);
      txt3=(DoubleToStr(AccountEquity(), 2));
      ObjectSetText("Lable3","Equity     "+txt3+"",16,"Times New Roman",col);
         //-------------------------   
      ObjectDelete("pipHiLo");
      ObjectCreate("pipHiLo",OBJ_LABEL,0,0,1.0);
      ObjectSet("pipHiLo", OBJPROP_CORNER, 1);
      ObjectSet("pipHiLo", OBJPROP_XDISTANCE, 20);
      ObjectSet("pipHiLo", OBJPROP_YDISTANCE, 20);
      txt3=(DoubleToStr(AccountEquity(), 2));
      ObjectSetText("pipHiLo","PipStepHilo "+PipStep_Hilo+"",12,"Times New Roman",Gold);
            //-------------------------   
      ObjectDelete("pip15");
      ObjectCreate("pip15",OBJ_LABEL,0,0,1.0);
      ObjectSet("pip15", OBJPROP_CORNER, 1);
      ObjectSet("pip15", OBJPROP_XDISTANCE, 20);
      ObjectSet("pip15", OBJPROP_YDISTANCE, 40);
      txt3=(DoubleToStr(AccountEquity(), 2));
      ObjectSetText("pip15","PipStep15    "+PipStep_15+"",12,"Times New Roman",Gold);
            //-------------------------   
      ObjectDelete("pip16");
      ObjectCreate("pip16",OBJ_LABEL,0,0,1.0);
      ObjectSet("pip16", OBJPROP_CORNER, 1);
      ObjectSet("pip16", OBJPROP_XDISTANCE, 20);
      ObjectSet("pip16", OBJPROP_YDISTANCE, 60);
      txt3=(DoubleToStr(AccountEquity(), 27));
      ObjectSetText("pip16","PipStep16   "+PipStep_16+"",12,"Times New Roman",Gold);
      
      OnScreenDelay = 0;
      } else {
         OnScreenDelay += 1;
      }
   }
   //=================
   if (PeriodRSI == 1) PerRSI =PERIOD_M1; 
   if (PeriodRSI == 2) PerRSI =PERIOD_M5; 
   if (PeriodRSI == 3) PerRSI =PERIOD_M15; 
   if (PeriodRSI == 4) PerRSI =PERIOD_M30; 
   if (PeriodRSI == 5) PerRSI =PERIOD_H1; 
   if (PeriodRSI == 6) PerRSI =PERIOD_H4; 
   if (PeriodRSI == 7) PerRSI =PERIOD_D1; 
   if (PeriodRSI == 8) PerRSI =PERIOD_W1; 
   if (PeriodRSI == 9) PerRSI =PERIOD_MN1;
   if (PeriodRSI == 0) PerRSI =Period();
   
   //================= 
   //=================
   //ForestGreen' YellowGreen' Yellow' OrangeRed' Red

   {

    //=======================================================================//
    //                 Программный код Ilan_Hilo_RSI                         //
    //=======================================================================//
  {
   double PrevCl_Hilo; //переменная Hilo
   double CurrCl_Hilo; //переменная Hilo
   double l_iclose_8;  //переменная Ilan_1.5
   double l_iclose_16; //переменная Ilan_1.6
   //=======================
   double LotExponent_Hilo = LotExponent;
   int lotdecimal_Hilo = lotdecimal;
   double TakeProfit_Hilo = TakeProfit;
   bool UseEquityStop_Hilo = UseEquityStop;        
   double TotalEquityRisk_Hilo = TotalEquityRisk; // риск в процентах от депозита
   bool UseTrailingStop_Hilo = UseTrailingStop;
   double TrailStart_Hilo = TrailStart;
   double TrailStop_Hilo = TrailStop;
   //double PipStep_Hilo = PipStep;//30
   double slip_Hilo = slip;        // проскальзывание
                         
   //=========
   ord_Hilo = CountTrades_Hilo();
   if (Turbo) 
   {   
   if (ord_Hilo == 1) PipStep_Hilo = PipStep/3;
   if (ord_Hilo == 2) PipStep_Hilo = PipStep/3*2;
   if (ord_Hilo >= 3) PipStep_Hilo = PipStep;
   } else PipStep_Hilo = PipStep;
   
   if (MarioTurbo) 
   {   
      PipStep_Hilo = NormalizeDouble(PipStep * ord_Hilo / MarioTurboFactor,0);
      //Print("HiLoPip: " + DoubleToString(PipStep_Hilo,0));
   } 
     
   
   //=========
   //=======================
   if(MM==true)
   {if (MathCeil(AccountBalance ()) < 2000)       // MM = если депо меньше 2000, то лот = Lots (0.01), иначе- % от депо
    { double Lots_Hilo = Lots;
     }  
     else
     {Lots_Hilo = 0.00001 * MathCeil(AccountBalance ());
     }
    }
     else Lots_Hilo = Lots;
  
   if (UseTrailingStop_Hilo) TrailingAlls_Hilo(TrailStart_Hilo, TrailStop_Hilo, AveragePrice_Hilo);
   if (UseTimeOut_Hilo) {
      if (TimeCurrent() >= expiration_Hilo) {
         CloseThisSymbolAll_Hilo();
         Print("Closed All due_Hilo to TimeOut");
      }
   }
   if (timeprev_Hilo == Time[0]) return (0);
   timeprev_Hilo = Time[0];
   double CurrentPairProfit_Hilo = CalculateProfit_Hilo();
   if (UseEquityStop_Hilo) {
      if (CurrentPairProfit_Hilo < 0.0 && MathAbs(CurrentPairProfit_Hilo) > TotalEquityRisk_Hilo / 100.0 * AccountEquityHigh_Hilo()) {
         CloseThisSymbolAll_Hilo();
         Print("Closed All due_Hilo to Stop Out");
         NewOrdersPlaced_Hilo = FALSE;
      }
   }
   total_Hilo = CountTrades_Hilo();
   if (total_Hilo == 0) flag_Hilo = FALSE;
   for (cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--) {
      OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo) {
         if (OrderType() == OP_BUY) {
            LongTrade_Hilo = TRUE;
            ShortTrade_Hilo = FALSE;
            break;
         }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo) {
         if (OrderType() == OP_SELL) {
            LongTrade_Hilo = FALSE;
            ShortTrade_Hilo = TRUE;
            break;
         }
      }
   }
   if (total_Hilo > 0 && total_Hilo < MaxTrades_Hilo) {
      RefreshRates();
      LastBuyPrice_Hilo = FindLastBuyPrice_Hilo();
      LastSellPrice_Hilo = FindLastSellPrice_Hilo();
      if (LongTrade_Hilo && LastBuyPrice_Hilo - Ask >= PipStep_Hilo * Point) TradeNow_Hilo = TRUE;
      if (ShortTrade_Hilo && Bid - LastSellPrice_Hilo >= PipStep_Hilo * Point) TradeNow_Hilo = TRUE;
   }
   if (total_Hilo < 1) {
      ShortTrade_Hilo = FALSE;
      LongTrade_Hilo = FALSE;
      TradeNow_Hilo = TRUE;
      StartEquity_Hilo = AccountEquity();
   }
   if (TradeNow_Hilo) {
      LastBuyPrice_Hilo = FindLastBuyPrice_Hilo();
      LastSellPrice_Hilo = FindLastSellPrice_Hilo();
      if (ShortTrade_Hilo) {
         NumOfTrades_Hilo = total_Hilo;
         iLots_Hilo = NormalizeDouble(Lots_Hilo * MathPow(LotExponent_Hilo, NumOfTrades_Hilo), lotdecimal_Hilo);
         RefreshRates();
         ticket_Hilo = OpenPendingOrder_Hilo(1, iLots_Hilo, NormalizeDouble(Bid,Digits), slip_Hilo, NormalizeDouble(Ask,Digits), 0, 0, EAName_Hilo + "-" + NumOfTrades_Hilo, MagicNumber_Hilo, 0, HotPink);
         if (ticket_Hilo < 0) 
         {
            Print("Error: ", GetLastError());
            return (0);
         }
         LastSellPrice_Hilo = FindLastSellPrice_Hilo();
         TradeNow_Hilo = FALSE;
         NewOrdersPlaced_Hilo = TRUE;
      } else {
         if (LongTrade_Hilo) {
            NumOfTrades_Hilo = total_Hilo;
            iLots_Hilo = NormalizeDouble(Lots_Hilo * MathPow(LotExponent_Hilo, NumOfTrades_Hilo), lotdecimal_Hilo);
            ticket_Hilo = OpenPendingOrder_Hilo(0, iLots_Hilo, NormalizeDouble(Ask,Digits), slip_Hilo, NormalizeDouble(Bid,Digits), 0, 0, EAName_Hilo + "-" + NumOfTrades_Hilo, MagicNumber_Hilo, 0, Lime);
            if (ticket_Hilo < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            LastBuyPrice_Hilo = FindLastBuyPrice_Hilo();
            TradeNow_Hilo = FALSE;
            NewOrdersPlaced_Hilo = TRUE;
         }
      }
   }
   if (TradeNow_Hilo && total_Hilo < 1) {
      PrevCl_Hilo = iHigh(Symbol(), 0, 1);
      CurrCl_Hilo =  iLow(Symbol(), 0, 2);
      SellLimit_Hilo = NormalizeDouble(Bid,Digits);
      BuyLimit_Hilo = NormalizeDouble(Ask,Digits);
      if (!ShortTrade_Hilo && !LongTrade_Hilo) {
         NumOfTrades_Hilo = total_Hilo;
         iLots_Hilo = NormalizeDouble(Lots_Hilo * MathPow(LotExponent_Hilo, NumOfTrades_Hilo), lotdecimal_Hilo);
         
          //=============ограничения на работу утром понедельника и вечер пятницы========================//
         
         //if(
         //    (CloseFriday==true&&DayOfWeek()==5&&TimeCurrent()>=StrToTime(CloseFridayHour+":00"))
         //  ||(OpenMondey ==true&&DayOfWeek()==1&&TimeCurrent()<=StrToTime(OpenMondeyHour +":00"))
         //  ) return(0);
         
         //=============================================================================================//
        
        if (NewCycle) {
         if (PrevCl_Hilo > CurrCl_Hilo) {        

            //HHHHHHHH~~~~~~~~~~~~~ Индюк RSI ~~~~~~~~~~HHHHHHHHH~~~~~~~~~~~~~~~//       
            if (iRSI(NULL, PerRSI, 14, PRICE_CLOSE, 1) > 30.0) {
               ticket_Hilo = OpenPendingOrder_Hilo(1, iLots_Hilo, SellLimit_Hilo, slip_Hilo, SellLimit_Hilo, 0, 0, EAName_Hilo + "-" + NumOfTrades_Hilo, MagicNumber_Hilo, 0, HotPink);
               if (ticket_Hilo < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               LastBuyPrice_Hilo = FindLastBuyPrice_Hilo();
               NewOrdersPlaced_Hilo = TRUE;
            }
         } else {

            //HHHHHHHH~~~~~~~~~~~~~ Индюк RSI ~~~~~~~~~HHHHHHHHHH~~~~~~~~~~~~~~~~~
            if (iRSI(NULL, PerRSI, 14, PRICE_CLOSE, 1) < 70.0) {
               ticket_Hilo = OpenPendingOrder_Hilo(0, iLots_Hilo, BuyLimit_Hilo, slip_Hilo, BuyLimit_Hilo, 0, 0, EAName_Hilo + "-" + NumOfTrades_Hilo, MagicNumber_Hilo, 0, Lime);
               if (ticket_Hilo < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               LastSellPrice_Hilo = FindLastSellPrice_Hilo();
               NewOrdersPlaced_Hilo = TRUE;
            }
         }
         }
         //=====================================================
       if (ticket_Hilo > 0) expiration_Hilo = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours_Hilo);
       TradeNow_Hilo = FALSE;
       }
       }
       total_Hilo = CountTrades_Hilo();
       AveragePrice_Hilo = 0;
       double Count_Hilo = 0;
       
       //--------------------   COUNT -----------------------------
       
      for (cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--) {
        OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES);
        if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
        if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo) {
            if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
                AveragePrice_Hilo += OrderOpenPrice() * OrderLots();
                Count_Hilo += OrderLots();
            }
          }
       }// end for
       
       if (total_Hilo > 0) AveragePrice_Hilo = NormalizeDouble(AveragePrice_Hilo / Count_Hilo, Digits);
       if (NewOrdersPlaced_Hilo) {
         for (cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--) {
            OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo) {
                if (OrderType() == OP_BUY) {
                    PriceTarget_Hilo = AveragePrice_Hilo + TakeProfit_Hilo * Point;
                    BuyTarget_Hilo = PriceTarget_Hilo;
                    Stopper_Hilo = AveragePrice_Hilo - Stoploss_Hilo * Point;
                    flag_Hilo = TRUE;
                }
             }
             if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo) {
                 if (OrderType() == OP_SELL) {
                     PriceTarget_Hilo = AveragePrice_Hilo - TakeProfit_Hilo * Point;
                     SellTarget_Hilo = PriceTarget_Hilo;
                     Stopper_Hilo = AveragePrice_Hilo + Stoploss_Hilo * Point;
                     flag_Hilo = TRUE;
                 }
              }
           }
         }// end  - if (NewOrdersPlaced_Hilo)
         //----------------------------------------------------------------------------------
         if (NewOrdersPlaced_Hilo) {
            if (flag_Hilo == TRUE) {
                for (cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--) {
                     OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES);
                     if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
                     if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo)// OrderModify(OrderTicket(), AveragePrice_Hilo, OrderStopLoss(), PriceTarget_Hilo, 0, Yellow);
                     //===
                     while(!OrderModify(OrderTicket(), AveragePrice_Hilo, OrderStopLoss(), PriceTarget_Hilo, 0, Yellow))
                     {
                      Sleep(1000);RefreshRates();
                     }                                                                      
                     NewOrdersPlaced_Hilo = FALSE;
                }
             }
         }// end if (NewOrdersPlaced_Hilo)

         //========================================================================//
         //                       ПРОГРАМНЫЙ КОД Ilan 1.5                          //
         //========================================================================//
         //double l_iclose_8;
         //double l_iclose_16;
         //=======================
         double LotExponent_15 = LotExponent;
         int lotdecimal_15 = lotdecimal;
         double TakeProfit_15 = TakeProfit;
         bool UseEquityStop_15 = UseEquityStop;        
      double TotalEquityRisk_15 = TotalEquityRisk;// риск в процентах от депозита
     bool UseTrailingStop_15 = UseTrailingStop;
    double TrailStart_15 = TrailStart;
   double TrailStop_15 = TrailStop;
   //double PipStep_15 = PipStep;//30
   double slip_15 = slip;                      // проскальзывание
  
  //
  
     //=================
   int _TimeFrameCloseValue = 0;
   if (TimeFrameCloseValue == 1) _TimeFrameCloseValue =PERIOD_M1; 
   if (TimeFrameCloseValue == 2) _TimeFrameCloseValue =PERIOD_M5; 
   if (TimeFrameCloseValue == 3) _TimeFrameCloseValue =PERIOD_M15; 
   if (TimeFrameCloseValue == 4) _TimeFrameCloseValue =PERIOD_M30; 
   if (TimeFrameCloseValue == 5) _TimeFrameCloseValue =PERIOD_H1; 
   if (TimeFrameCloseValue == 6) _TimeFrameCloseValue =PERIOD_H4; 
   if (TimeFrameCloseValue == 7) _TimeFrameCloseValue =PERIOD_D1; 
   if (TimeFrameCloseValue == 8) _TimeFrameCloseValue =PERIOD_W1; 
   if (TimeFrameCloseValue == 9) _TimeFrameCloseValue =PERIOD_MN1;
   if (TimeFrameCloseValue == 0) _TimeFrameCloseValue =Period();
    
  //
  
   //=========
   ord_15 = CountTrades_15();   
   if (Turbo)
   { 
   if (ord_15 == 1) PipStep_15 = PipStep/3;
   if (ord_15 == 2) PipStep_15 = PipStep/3*2;
   if (ord_15 >= 3) PipStep_15 = PipStep;
   }
   else PipStep_15 = PipStep;
   
   if (MarioTurbo) 
   {   
      PipStep_15 = NormalizeDouble( PipStep*ord_15/MarioTurboFactor,0);
   } 
   
   //=========

   //=======================
   if(MM==true)
   {if (MathCeil(AccountBalance ()) < 2000)    // MM = если депо меньше 2000, то лот = Lots (0.01), иначе- % от депо
     { double Lots_15 = Lots;
     }  
     else
     {Lots_15 = 0.00001 * MathCeil(AccountBalance ());
     }
    }
     else Lots_15 = Lots;
   //=======================
         //=============ограничения на работу утром понедельника и вечер пятницы========================//
         
         //if(
         //    (CloseFriday==true&&DayOfWeek()==5&&TimeCurrent()>=StrToTime(CloseFridayHour+":00"))
         //  ||(OpenMondey ==true&&DayOfWeek()==1&&TimeCurrent()<=StrToTime(OpenMondeyHour +":00"))
         //  ) return(0);
         
         //=============================================================================================//
   
   if (UseTrailingStop_15) TrailingAlls_15(TrailStart_15, TrailStop_15, g_price_212_15);
   if (UseTimeOut_15) {
      if (TimeCurrent() >= gi_284_15) {
         CloseThisSymbolAll_15();
         Print("Closed All due to TimeOut");
      }
   }
   if (gi_280_15 != Time[0])
   {
   gi_280_15 = Time[0];
   double ld_0_15 = CalculateProfit_15();
   if (UseEquityStop_15) {
      if (ld_0_15 < 0.0 && MathAbs(ld_0_15) > TotalEquityRisk_15 / 100.0 * AccountEquityHigh_15()) {
         CloseThisSymbolAll_15();
         Print("Closed All due to Stop Out");
         gi_332_15 = FALSE;
      }
   }
   gi_304_15 = CountTrades_15();
   if (gi_304_15 == 0) gi_268_15 = FALSE;
   for (g_pos_300_15 = OrdersTotal() - 1; g_pos_300_15 >= 0; g_pos_300_15--) {
      OrderSelect(g_pos_300_15, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) {
         if (OrderType() == OP_BUY) {
            gi_320_15 = TRUE;
            gi_324_15 = FALSE;
            break;
         }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) {
         if (OrderType() == OP_SELL) {
            gi_320_15 = FALSE;
            gi_324_15 = TRUE;
            break;
         }
      }
   }
   if (gi_304_15 > 0 && gi_304_15 < MaxTrades_15) {
      RefreshRates();
      gd_236_15 = FindLastBuyPrice_15();
      gd_244_15 = FindLastSellPrice_15();
      if (gi_320_15 && gd_236_15 - Ask >= PipStep_15 * Point) gi_316_15 = TRUE;
      if (gi_324_15 && Bid - gd_244_15 >= PipStep_15 * Point) gi_316_15 = TRUE;
   }
   if (gi_304_15 < 1) {
      gi_324_15 = FALSE;
      gi_320_15 = FALSE;
      gi_316_15 = TRUE;
      gd_188_15 = AccountEquity();
   }
   if (gi_316_15) {
      gd_236_15 = FindLastBuyPrice_15();
      gd_244_15 = FindLastSellPrice_15();
      if (gi_324_15) {
         gi_288_15 = gi_304_15;
         gd_292_15 = NormalizeDouble(Lots_15 * MathPow(LotExponent_15, gi_288_15), lotdecimal_15);
         RefreshRates();
         gi_328_15 = OpenPendingOrder_15(1, gd_292_15, NormalizeDouble(Bid,Digits), slip_15, NormalizeDouble(Ask,Digits), 0, 0, gs_ilan_272_15 + "-" + gi_288_15, g_magic_176_15, 0, HotPink);
         if (gi_328_15 < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         gd_244_15 = FindLastSellPrice_15();
         gi_316_15 = FALSE;
         gi_332_15 = TRUE;
      } else {
         if (gi_320_15) {
            gi_288_15 = gi_304_15;
            gd_292_15 = NormalizeDouble(Lots_15 * MathPow(LotExponent_15, gi_288_15), lotdecimal_15);
            gi_328_15 = OpenPendingOrder_15(0, gd_292_15, NormalizeDouble(Ask,Digits), slip_15, NormalizeDouble(Bid,Digits), 0, 0, gs_ilan_272_15 + "-" + gi_288_15, g_magic_176_15, 0, Lime);
            if (gi_328_15 < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            gd_236_15 = FindLastBuyPrice_15();
            gi_316_15 = FALSE;
            gi_332_15 = TRUE;
         }
      }
   }
   }
   if(time_15!=iTime(NULL,OpenNewTF_15,0)){
     int totals_15=OrdersTotal();
     int orders_15=0;
     for(int total_15=totals_15; total_15>=1; total_15--){
        OrderSelect(total_15-1,SELECT_BY_POS,MODE_TRADES);
        if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
        if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) {
            orders_15++;
        }
     }// for
     if (totals_15==0 || orders_15 < 1) {
      l_iclose_8 = iClose(Symbol(), _TimeFrameCloseValue, 2);
      l_iclose_16 = iClose(Symbol(), _TimeFrameCloseValue, 1);
      g_bid_220_15 = NormalizeDouble(Bid,Digits);
      g_ask_228_15 = NormalizeDouble(Ask,Digits);
      if (!gi_324_15 && !gi_320_15) {
         gi_288_15 = gi_304_15;
         gd_292_15 = NormalizeDouble(Lots_15 * MathPow(LotExponent, gi_288_15), lotdecimal_15);
         if (l_iclose_8 > l_iclose_16) {
             if (NewCycle){
                gi_328_15 = OpenPendingOrder_15(1, gd_292_15, g_bid_220_15, slip_15, g_bid_220_15, 0, 0, gs_ilan_272_15 + "-" + gi_288_15, g_magic_176_15, 0, HotPink);
                if (gi_328_15 < 0) {
                   Print("Error: ", GetLastError());
                   return (0);
                }// if
                gd_236_15 = FindLastBuyPrice_15();
                gi_332_15 = TRUE;
             }// if newcycle
         } 
       }// if (!gi_324_15 && !gi_320_15)
       else {if (NewCycle) {
            gi_328_15 = OpenPendingOrder_15(0, gd_292_15, g_ask_228_15, slip_15, g_ask_228_15, 0, 0, gs_ilan_272_15 + "-" + gi_288_15, g_magic_176_15, 0, Lime);
            if (gi_328_15 < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            gd_244_15 = FindLastSellPrice_15();
            gi_332_15 = TRUE;
          }//end  if newcycle
         }// end  else if
        if (gi_328_15 > 0) gi_284_15 = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours_15);
        gi_316_15 = FALSE;
         
     }// end - if (totals_15==0 || orders_15 < 1) {
     time_15=iTime(NULL,OpenNewTF_15,0);
   }// end  ---  if(time_15!=iTime(NULL,OpenNewTF_15,0)){
   
   
   gi_304_15 = CountTrades_15();
   g_price_212_15 = 0;
   double ld_24_15 = 0;
   
   for (g_pos_300_15 = OrdersTotal() - 1; g_pos_300_15 >= 0; g_pos_300_15--) {
      OrderSelect(g_pos_300_15, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            g_price_212_15 += OrderOpenPrice() * OrderLots();
            ld_24_15 += OrderLots();
         }
      }
   }// end  for 
   
   if (gi_304_15 > 0) g_price_212_15 = NormalizeDouble(g_price_212_15 / ld_24_15, Digits);
   if (gi_332_15) {
      for (g_pos_300_15 = OrdersTotal() - 1; g_pos_300_15 >= 0; g_pos_300_15--) {
         OrderSelect(g_pos_300_15, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) {
            if (OrderType() == OP_BUY) {
               g_price_180_15 = g_price_212_15 + TakeProfit_15 * Point;
               gd_unused_196_15 = g_price_180_15;
               gd_308_15 = g_price_212_15 - Stoploss_15 * Point;
               gi_268_15 = TRUE;}
         } // end  -- if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) {
            if (OrderType() == OP_SELL) {
               g_price_180_15 = g_price_212_15 - TakeProfit_15 * Point;
               gd_unused_204_15 = g_price_180_15;
               gd_308_15 = g_price_212_15 + Stoploss_15 * Point;
               gi_268_15 = TRUE;}
         }
      }// end  - for
   }// end  - if (gi_332_15) 
   if (gi_332_15) {
      if (gi_268_15 == TRUE) {
         for (g_pos_300_15 = OrdersTotal() - 1; g_pos_300_15 >= 0; g_pos_300_15--) {
            OrderSelect(g_pos_300_15, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) 
            //OrderModify(OrderTicket(), g_price_212_15, OrderStopLoss(), g_price_180_15, 0, Yellow);           
            //===
            while(!OrderModify(OrderTicket(), g_price_212_15, OrderStopLoss(), g_price_180_15, 0, Yellow))// модифицируем все открытые ордера...
            {Sleep(1000);RefreshRates();}                                                                 //..причём здесь добавлена проверка, котрая должна по идее исключить.. 
            //===
            gi_332_15 = FALSE;
         }
      }
   }// end - if (gi_332_15)
   //========================================================================//
   //                       ПРОГРАМНЫЙ КОД Ilan 1.6                          //
   //========================================================================//
   //   double l_iclose_8;
   //   double l_iclose_16;
   //=======================
   double LotExponent_16 = LotExponent;
   int lotdecimal_16 = lotdecimal;
   double TakeProfit_16 = TakeProfit;
   bool UseEquityStop_16 = UseEquityStop;
   double TotalEquityRisk_16 = TotalEquityRisk;// риск в процентах от депозита
   bool UseTrailingStop_16 = UseTrailingStop;
   double TrailStart_16 = TrailStart;
   double TrailStop_16 = TrailStop;
   //double PipStep_16 = PipStep;//30
   double slip_16 = slip;                      // проскальзывание
   
   //=========
   ord_16 = CountTrades_16();
   if (Turbo)
   {   
   if (ord_16 == 1) PipStep_16 = PipStep/3;
   if (ord_16 == 2) PipStep_16 = PipStep/3*2;
   if (ord_16 >= 3) PipStep_16 = PipStep;
   }
   else PipStep_16 = PipStep;
   
   if (MarioTurbo) 
   {   
      PipStep_16 = NormalizeDouble( PipStep*ord_16/MarioTurboFactor,0);
   } 
   
   //=========

   //=======================
   // манименеджмент      //
   //=======================
   if(MM==true)
   {if (MathCeil(AccountBalance ()) < 2000)    // MM = если депо меньше 2000, то лот = Lots (0.01), иначе- % от депо
     { double Lots_16 = Lots;
     }  
     else
     {Lots_16 = 0.00001 * MathCeil(AccountBalance ());
     }
    }
     else Lots_16 = Lots;

   //=======================
         //=============ограничения на работу утром понедельника и вечер пятницы========================//
         
         //if(
         //    (CloseFriday==true&&DayOfWeek()==5&&TimeCurrent()>=StrToTime(CloseFridayHour+":00"))
         //  ||(OpenMondey ==true&&DayOfWeek()==1&&TimeCurrent()<=StrToTime(OpenMondeyHour+ ":00"))
         //  ) return(0);
         
         //=============================================================================================//
   
   if (UseTrailingStop_16) TrailingAlls_16(TrailStart_16, TrailStop_16, g_price_212_16);
   if (UseTimeOut_16) {
      if (TimeCurrent() >= gi_284_16) {
         CloseThisSymbolAll_16();
         Print("Closed All due to TimeOut");
      }
   }
   if (gi_280_16 != Time[0])
   {
   gi_280_16 = Time[0];
   double ld_0_16 = CalculateProfit_16();
   if (UseEquityStop_16) {
      if (ld_0_16 < 0.0 && MathAbs(ld_0_16) > TotalEquityRisk_16 / 100.0 * AccountEquityHigh_16()) {
         CloseThisSymbolAll_16();
         Print("Closed All due to Stop Out");
         gi_332_16 = FALSE;
      }
   }
   gi_304_16 = CountTrades_16();
   if (gi_304_16 == 0) gi_268_16 = FALSE;
   
   for (g_pos_300_16 = OrdersTotal() - 1; g_pos_300_16 >= 0; g_pos_300_16--) {
      OrderSelect(g_pos_300_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16) {
         if (OrderType() == OP_BUY) {
            gi_320_16 = TRUE;
            gi_324_16 = FALSE;
            break; }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16) {
         if (OrderType() == OP_SELL) {
            gi_320_16 = FALSE;
            gi_324_16 = TRUE;
            break;}
      }
   }// end  - for
   
   if (gi_304_16 > 0 && gi_304_16 < MaxTrades_16) {
      RefreshRates();
      gd_236_16 = FindLastBuyPrice_16();
      gd_244_16 = FindLastSellPrice_16();
      if (gi_320_16 && gd_236_16 - Ask >= PipStep_16 * Point) gi_316_16 = TRUE;
      if (gi_324_16 && Bid - gd_244_16 >= PipStep_16 * Point) gi_316_16 = TRUE;
   }
   
   if (gi_304_16 < 1) {
      gi_324_16 = FALSE;
      gi_320_16 = FALSE;
      gi_316_16 = TRUE;
      gd_188_16 = AccountEquity();
   }
   
   if (gi_316_16) {
      gd_236_16 = FindLastBuyPrice_16();
      gd_244_16 = FindLastSellPrice_16();
      if (gi_324_16) {
         gi_288_16 = gi_304_16;
         gd_292_16 = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, gi_288_16), lotdecimal_16);
         RefreshRates();
         gi_328_16 = OpenPendingOrder_16(1, gd_292_16, NormalizeDouble(Bid,Digits), slip_16, NormalizeDouble(Ask,Digits), 0, 0, gs_ilan_272_16 + "-" + gi_288_16, g_magic_176_16, 0, HotPink);
         if (gi_328_16 < 0) {
            Print("Error: ", GetLastError());
            return (0);
         }
         gd_244_16 = FindLastSellPrice_16();
         gi_316_16 = FALSE;
         gi_332_16 = TRUE;
      } 
      else {
         if (gi_320_16) {
            gi_288_16 = gi_304_16;
            gd_292_16 = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, gi_288_16), lotdecimal_16);
            gi_328_16 = OpenPendingOrder_16(0, gd_292_16, NormalizeDouble(Ask,Digits), slip_16, NormalizeDouble(Bid,Digits), 0, 0, gs_ilan_272_16 + "-" + gi_288_16, g_magic_176_16, 0, Lime);
            if (gi_328_16 < 0) {
               Print("Error: ", GetLastError());
               return (0);
            }
            gd_236_16 = FindLastBuyPrice_16();
            gi_316_16 = FALSE;
            gi_332_16 = TRUE;
         }
      }// end else
    }//
   }// end -- if (gi_316_16) {
   
   if(time_16!=iTime(NULL,OpenNewTF_16,0)){
      int totals_16=OrdersTotal();
      int orders_16=0;
      for(int total_16=totals_16; total_16>=1; total_16--){
          OrderSelect(total_16-1,SELECT_BY_POS,MODE_TRADES);
          if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
          if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16) {orders_16++;}
      }// end - for
      if (totals_16==0 || orders_16 < 1) {
         l_iclose_8/*_16*/ = iClose(Symbol(), 0, 2);
         l_iclose_16/*_16*/ = iClose(Symbol(), 0, 1);
         g_bid_220_16 = NormalizeDouble(Bid,Digits);
         g_ask_228_16 = NormalizeDouble(Ask,Digits);
         if (!gi_324_16 && !gi_320_16) {
             gi_288_16 = gi_304_16;
             gd_292_16 = NormalizeDouble(Lots_16 * MathPow(LotExponent_16, gi_288_16), lotdecimal_16);
             if (NewCycle) {
             if (l_iclose_8/*_16*/ > l_iclose_16/*_16*/) {
                 if (iRSI(NULL, PerRSI, 14, PRICE_CLOSE, 1) > 30.0) {
                  gi_328_16 = OpenPendingOrder_16(1, gd_292_16, g_bid_220_16, slip_16, g_bid_220_16, 0, 0, gs_ilan_272_16 + "-" + gi_288_16, g_magic_176_16, 0, HotPink);
                  if (gi_328_16 < 0) { Print("Error: ", GetLastError());
                      return (0);}
                  gd_236_16 = FindLastBuyPrice_16();
                  gi_332_16 = TRUE;
            }// end 
         } // end  -- if (!gi_324_16 && !gi_320_16) {
         else {
            if (iRSI(NULL, PerRSI, 14, PRICE_CLOSE, 1) < 70.0) {
               gi_328_16 = OpenPendingOrder_16(0, gd_292_16, g_ask_228_16, slip_16, g_ask_228_16, 0, 0, gs_ilan_272_16 + "-" + gi_288_16, g_magic_176_16, 0, Lime);
               if (gi_328_16 < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               gd_244_16 = FindLastSellPrice_16();
               gi_332_16 = TRUE;
            }
         }// end - else
       }//end - if (totals_16==0 || orders_16 < 1) {
       if (gi_328_16 > 0) gi_284_16 = TimeCurrent() + 60.0 * (60.0 * MaxTradeOpenHours_16);
       gi_316_16 = FALSE;
      }
   }
   time_16=iTime(NULL,OpenNewTF_16,0);
   }//  end  if(time_16!=iTime(NULL,OpenNewTF_16,0)){
   
   gi_304_16 = CountTrades_16();
   g_price_212_16 = 0;
   double ld_24_16 = 0;
   for (g_pos_300_16 = OrdersTotal() - 1; g_pos_300_16 >= 0; g_pos_300_16--) {
      OrderSelect(g_pos_300_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            g_price_212_16 += OrderOpenPrice() * OrderLots();
            ld_24_16 += OrderLots();
         }
      }
   }// end  -  for
   
   if (gi_304_16 > 0) g_price_212_16 = NormalizeDouble(g_price_212_16 / ld_24_16, Digits);
   
   if (gi_332_16) {
      for (g_pos_300_16 = OrdersTotal() - 1; g_pos_300_16 >= 0; g_pos_300_16--) {
         OrderSelect(g_pos_300_16, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16) {
            if (OrderType() == OP_BUY) {
               g_price_180_16 = g_price_212_16 + TakeProfit_16 * Point;
               gd_unused_196_16 = g_price_180_16;
               gd_308_16 = g_price_212_16 - Stoploss_16 * Point;
               gi_268_16 = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16) {
            if (OrderType() == OP_SELL) {
               g_price_180_16 = g_price_212_16 - TakeProfit_16 * Point;
               gd_unused_204_16 = g_price_180_16;
               gd_308_16 = g_price_212_16 + Stoploss_16 * Point;
               gi_268_16 = TRUE;
            }
         }
      }
   }// end  - if (gi_332_16) {
   
   if (gi_332_16) {
      if (gi_268_16 == TRUE) {
         for (g_pos_300_16 = OrdersTotal() - 1; g_pos_300_16 >= 0; g_pos_300_16--) {
            OrderSelect(g_pos_300_16, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16) 
            //OrderModify(OrderTicket(), g_price_212_16, OrderStopLoss(), g_price_180_16, 0, Yellow);
            //===
            while(!OrderModify(OrderTicket(), g_price_212_16, OrderStopLoss(), g_price_180_16, 0, Yellow))// модифицируем все открытые ордера...
            {Sleep(1000);RefreshRates();}                                                                 //..причём здесь добавлена проверка, котрая должна по идее исключить.. 
            //===
            gi_332_16 = FALSE;
         }// end  - for
      }// end  -- if
   }// end - if (gi_332_16) {
  }
 }

//=============================  END OF START FUNCTION
//=============================
end=GetTickCount();
      if ( end-begin>0)
      { current = (end-begin);
        
       if ( max<current )
        { max = (end-begin);}}
        
        //------------------------ Check Loop speed

return (0);
}

//=============================
int CountTrades_Hilo() {
int count_Hilo = 0;
for (int trade_Hilo = OrdersTotal() - 1; trade_Hilo >= 0; trade_Hilo--) {
OrderSelect(trade_Hilo, SELECT_BY_POS, MODE_TRADES);
if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo)
if (OrderType() == OP_SELL || OrderType() == OP_BUY) count_Hilo++;
}
return (count_Hilo);
}

//=============================

void CloseThisSymbolAll_Hilo() {
for (int trade_Hilo = OrdersTotal() - 1; trade_Hilo >= 0; trade_Hilo--) {
OrderSelect(trade_Hilo, SELECT_BY_POS, MODE_TRADES);
if (OrderSymbol() == Symbol()) {
if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo) {
if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, slip_Hilo, Blue);
if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, slip_Hilo, Red);
}
Sleep(1000);
}
}
}

//=============================
int OpenPendingOrder_Hilo(int pType_Hilo, double pLots_Hilo, double pPrice_Hilo, int pSlippage_Hilo, double pr_Hilo, int sl_Hilo, int tp_Hilo, string pComment_Hilo, int pMagic_Hilo, int pDatetime_Hilo, color pColor_Hilo) {
int ticket_Hilo = 0;
int err_Hilo = 0;
int c_Hilo = 0;
int NumberOfTries_Hilo = 100;
switch (pType_Hilo) {
case 0:
for (c_Hilo = 0; c_Hilo < NumberOfTries_Hilo; c_Hilo++) {
RefreshRates();
ticket_Hilo = OrderSend(Symbol(), OP_BUY, pLots_Hilo, NormalizeDouble(Ask,Digits), pSlippage_Hilo, NormalizeDouble(StopLong_Hilo(Bid, sl_Hilo),Digits), NormalizeDouble(TakeLong_Hilo(Ask, tp_Hilo),Digits), pComment_Hilo, pMagic_Hilo, pDatetime_Hilo, pColor_Hilo);
err_Hilo = GetLastError();
if (err_Hilo == 0/* NO_ERROR */) break;
if (!(err_Hilo == 4/* SERVER_BUSY */ || err_Hilo == 137/* BROKER_BUSY */ || err_Hilo == 146/* TRADE_CONTEXT_BUSY */ || err_Hilo == 136/* OFF_QUOTES */)) break;
Sleep(5000);
}
break;
case 1:
for (c_Hilo = 0; c_Hilo < NumberOfTries_Hilo; c_Hilo++) {
ticket_Hilo = OrderSend(Symbol(), OP_SELL, pLots_Hilo, NormalizeDouble(Bid,Digits), pSlippage_Hilo, NormalizeDouble(StopShort_Hilo(Ask, sl_Hilo),Digits), NormalizeDouble(TakeShort_Hilo(Bid, tp_Hilo),Digits), pComment_Hilo, pMagic_Hilo, pDatetime_Hilo, pColor_Hilo);
err_Hilo = GetLastError();
if (err_Hilo == 0/* NO_ERROR */) break;
if (!(err_Hilo == 4/* SERVER_BUSY */ || err_Hilo == 137/* BROKER_BUSY */ || err_Hilo == 146/* TRADE_CONTEXT_BUSY */ || err_Hilo == 136/* OFF_QUOTES */)) break;
Sleep(5000);
}
}

return (ticket_Hilo);
}

//=============================
double StopLong_Hilo(double price_Hilo, int stop_Hilo) {
if (stop_Hilo == 0) return (0);
else return (price_Hilo - stop_Hilo * Point);
}
//=============================
double StopShort_Hilo(double price_Hilo, int stop_Hilo) {
if (stop_Hilo == 0) return (0);
else return (price_Hilo + stop_Hilo * Point);
}
//=============================
double TakeLong_Hilo(double price_Hilo, int stop_Hilo) {
if (stop_Hilo == 0) return (0);
else return (price_Hilo + stop_Hilo * Point);
}
//=============================
double TakeShort_Hilo(double price_Hilo, int stop_Hilo) {
if (stop_Hilo == 0) return (0);
else return (price_Hilo - stop_Hilo * Point);
}

//=============================
double CalculateProfit_Hilo() {
double Profit_Hilo = 0;
for (cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--) {
OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES);
if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo)
if (OrderType() == OP_BUY || OrderType() == OP_SELL) Profit_Hilo += OrderProfit();
}
return (Profit_Hilo);
}

//=============================

void TrailingAlls_Hilo(int pType_Hilo, int stop_Hilo, double AvgPrice_Hilo) {
int profit_Hilo;
double stoptrade_Hilo;
double stopcal_Hilo;
if (stop_Hilo != 0) {
for (int trade_Hilo = OrdersTotal() - 1; trade_Hilo >= 0; trade_Hilo--) {
if (OrderSelect(trade_Hilo, SELECT_BY_POS, MODE_TRADES)) {
if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
if (OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber_Hilo) {
if (OrderType() == OP_BUY) {
profit_Hilo = NormalizeDouble((Bid - AvgPrice_Hilo) / Point, 0);
if (profit_Hilo < pType_Hilo) continue;
stoptrade_Hilo = OrderStopLoss();
stopcal_Hilo = Bid - stop_Hilo * Point;
if (stoptrade_Hilo == 0.0 || (stoptrade_Hilo != 0.0 && stopcal_Hilo > stoptrade_Hilo)) OrderModify(OrderTicket(), AvgPrice_Hilo, stopcal_Hilo, OrderTakeProfit(), 0, Aqua);
}
if (OrderType() == OP_SELL) {
profit_Hilo = NormalizeDouble((AvgPrice_Hilo - Ask) / Point, 0);
if (profit_Hilo < pType_Hilo) continue;
stoptrade_Hilo = OrderStopLoss();
stopcal_Hilo = Ask + stop_Hilo * Point;
if (stoptrade_Hilo == 0.0 || (stoptrade_Hilo != 0.0 && stopcal_Hilo < stoptrade_Hilo)) OrderModify(OrderTicket(), AvgPrice_Hilo, stopcal_Hilo, OrderTakeProfit(), 0, Red);
}
}
Sleep(1000);
}
}
}
}

//=============================
double AccountEquityHigh_Hilo() {
if (CountTrades_Hilo() == 0) AccountEquityHighAmt_Hilo = AccountEquity();
if (AccountEquityHighAmt_Hilo < PrevEquity_Hilo) AccountEquityHighAmt_Hilo = PrevEquity_Hilo;
else AccountEquityHighAmt_Hilo = AccountEquity();
PrevEquity_Hilo = AccountEquity();
return (AccountEquityHighAmt_Hilo);
}

//=============================
double FindLastBuyPrice_Hilo() {
double oldorderopenprice_Hilo;
int oldticketnumber_Hilo;
double unused_Hilo = 0;
int ticketnumber_Hilo = 0;
for (int cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--) {
OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES);
if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo && OrderType() == OP_BUY) {
oldticketnumber_Hilo = OrderTicket();
if (oldticketnumber_Hilo > ticketnumber_Hilo) {
oldorderopenprice_Hilo = OrderOpenPrice();
unused_Hilo = oldorderopenprice_Hilo;
ticketnumber_Hilo = oldticketnumber_Hilo;
}
}
}
return (oldorderopenprice_Hilo);
}

//=============================
double FindLastSellPrice_Hilo() {
double oldorderopenprice_Hilo;
int oldticketnumber_Hilo;
double unused_Hilo = 0;
int ticketnumber_Hilo = 0;
for (int cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--) {
OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES);
if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber_Hilo) continue;
if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber_Hilo && OrderType() == OP_SELL) {
oldticketnumber_Hilo = OrderTicket();
if (oldticketnumber_Hilo > ticketnumber_Hilo) {
oldorderopenprice_Hilo = OrderOpenPrice();
unused_Hilo = oldorderopenprice_Hilo;
ticketnumber_Hilo = oldticketnumber_Hilo;
}
}
}





return (oldorderopenprice_Hilo);
}

//==========================================================================
//                   пользовательские ф-ции 1.5_1.6                       //
//==========================================================================

//========================================================================//
//=========================CountTrades_15=================================//
//========================================================================//
int CountTrades_15() {
   int l_count_0_15 = 0;
   for (int l_pos_4_15 = OrdersTotal() - 1; l_pos_4_15 >= 0; l_pos_4_15--) {
      OrderSelect(l_pos_4_15, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) l_count_0_15++;
   }
   return (l_count_0_15);
}

void CloseThisSymbolAll_15() {
   for (int l_pos_0_15 = OrdersTotal() - 1; l_pos_0_15 >= 0; l_pos_0_15--) {
      OrderSelect(l_pos_0_15, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, slip_15, Blue);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, slip_15, Red);
         }
         Sleep(1000);
      }
   }
}

int OpenPendingOrder_15(int ai_0_15, double a_lots_4_15, double a_price_12_15, int a_slippage_20_15, double ad_24_15, int ai_32_15, int ai_36_15, string a_comment_40_15, int a_magic_48_15, int a_datetime_52_15, color a_color_56_15) {
   int l_ticket_60_15 = 0;
   int l_error_64_15 = 0;
   int l_count_68_15 = 0;
   int li_72_15 = 100;
   switch (ai_0_15) {
   case 0:
      for (l_count_68_15 = 0; l_count_68_15 < li_72_15; l_count_68_15++) {
         RefreshRates();
         l_ticket_60_15 = OrderSend(Symbol(), OP_BUY, a_lots_4_15, NormalizeDouble(Ask,Digits), a_slippage_20_15, NormalizeDouble(StopLong_15(Bid, ai_32_15),Digits), NormalizeDouble(TakeLong_15(Ask, ai_36_15),Digits), a_comment_40_15, a_magic_48_15, a_datetime_52_15, a_color_56_15);
         l_error_64_15 = GetLastError();
         if (l_error_64_15 == 0/* NO_ERROR */) break;
         if (!(l_error_64_15 == 4/* SERVER_BUSY */ || l_error_64_15 == 137/* BROKER_BUSY */ || l_error_64_15 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64_15 == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (l_count_68_15 = 0; l_count_68_15 < li_72_15; l_count_68_15++) {
         l_ticket_60_15 = OrderSend(Symbol(), OP_SELL, a_lots_4_15, NormalizeDouble(Bid,Digits), a_slippage_20_15, NormalizeDouble(StopShort_15(Ask, ai_32_15),Digits), NormalizeDouble(TakeShort_15(Bid, ai_36_15),Digits), a_comment_40_15, a_magic_48_15, a_datetime_52_15, a_color_56_15);
         l_error_64_15 = GetLastError();
         if (l_error_64_15 == 0/* NO_ERROR */) break;
         if (!(l_error_64_15 == 4/* SERVER_BUSY */ || l_error_64_15 == 137/* BROKER_BUSY */ || l_error_64_15 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64_15 == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
   }
   return (l_ticket_60_15);
}

double StopLong_15(double ad_0_15, int ai_8_15) {
   if (ai_8_15 == 0) return (0);
   else return (ad_0_15 - ai_8_15 * Point);
}

double StopShort_15(double ad_0_15, int ai_8_15) {
   if (ai_8_15 == 0) return (0);
   else return (ad_0_15 + ai_8_15 * Point);
}

double TakeLong_15(double ad_0_15, int ai_8_15) {
   if (ai_8_15 == 0) return (0);
   else return (ad_0_15 + ai_8_15 * Point);
}

double TakeShort_15(double ad_0_15, int ai_8_15) {
   if (ai_8_15 == 0) return (0);
   else return (ad_0_15 - ai_8_15 * Point);
}

double CalculateProfit_15() {
   double ld_ret_0_15 = 0;
   for (g_pos_300_15 = OrdersTotal() - 1; g_pos_300_15 >= 0; g_pos_300_15--) {
      OrderSelect(g_pos_300_15, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) ld_ret_0_15 += OrderProfit();
   }
   return (ld_ret_0_15);
}

void TrailingAlls_15(int ai_0_15, int ai_4_15, double a_price_8_15) {
   int l_ticket_16_15;
   double l_ord_stoploss_20_15;
   double l_price_28_15;
   if (ai_4_15 != 0) {
      for (int l_pos_36_15 = OrdersTotal() - 1; l_pos_36_15 >= 0; l_pos_36_15--) {
         if (OrderSelect(l_pos_36_15, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == g_magic_176_15) {
               if (OrderType() == OP_BUY) {
                  l_ticket_16_15 = NormalizeDouble((Bid - a_price_8_15) / Point, 0);
                  if (l_ticket_16_15 < ai_0_15) continue;
                  l_ord_stoploss_20_15 = OrderStopLoss();
                  l_price_28_15 = Bid - ai_4_15 * Point;
                  if (l_ord_stoploss_20_15 == 0.0 || (l_ord_stoploss_20_15 != 0.0 && l_price_28_15 > l_ord_stoploss_20_15)) OrderModify(OrderTicket(), a_price_8_15, l_price_28_15, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  l_ticket_16_15 = NormalizeDouble((a_price_8_15 - Ask) / Point, 0);
                  if (l_ticket_16_15 < ai_0_15) continue;
                  l_ord_stoploss_20_15 = OrderStopLoss();
                  l_price_28_15 = Ask + ai_4_15 * Point;
                  if (l_ord_stoploss_20_15 == 0.0 || (l_ord_stoploss_20_15 != 0.0 && l_price_28_15 < l_ord_stoploss_20_15)) OrderModify(OrderTicket(), a_price_8_15, l_price_28_15, OrderTakeProfit(), 0, Red);
               }
            }
            Sleep(1000);
         }
      }
   }
}

double AccountEquityHigh_15() {
   if (CountTrades_15() == 0) gd_336_15 = AccountEquity();
   if (gd_336_15 < gd_344_15) gd_336_15 = gd_344_15;
   else gd_336_15 = AccountEquity();
   gd_344_15 = AccountEquity();
   return (gd_336_15);
}

double FindLastBuyPrice_15() {
   double l_ord_open_price_8_15;
   int l_ticket_24_15;
   double ld_unused_0_15 = 0;
   int l_ticket_20_15 = 0;
   for (int l_pos_16_15 = OrdersTotal() - 1; l_pos_16_15 >= 0; l_pos_16_15--) {
      OrderSelect(l_pos_16_15, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15 && OrderType() == OP_BUY) {
         l_ticket_24_15 = OrderTicket();
         if (l_ticket_24_15 > l_ticket_20_15) {
            l_ord_open_price_8_15 = OrderOpenPrice();
            ld_unused_0_15 = l_ord_open_price_8_15;
            l_ticket_20_15 = l_ticket_24_15;
         }
      }
   }
   return (l_ord_open_price_8_15);
}

double FindLastSellPrice_15() {
   double l_ord_open_price_8_15;
   int l_ticket_24_15;
   double ld_unused_0_15 = 0;
   int l_ticket_20_15 = 0;
   for (int l_pos_16_15 = OrdersTotal() - 1; l_pos_16_15 >= 0; l_pos_16_15--) {
      OrderSelect(l_pos_16_15, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_15) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_15 && OrderType() == OP_SELL) {
         l_ticket_24_15 = OrderTicket();
         if (l_ticket_24_15 > l_ticket_20_15) {
            l_ord_open_price_8_15 = OrderOpenPrice();
            ld_unused_0_15 = l_ord_open_price_8_15;
            l_ticket_20_15 = l_ticket_24_15;
         }
      }
   }
   return (l_ord_open_price_8_15);
}
//============================================================//
//======================CountTrades_16========================//
//============================================================//
int CountTrades_16() {
   int l_count_0_16 = 0;
   for (int l_pos_4_16 = OrdersTotal() - 1; l_pos_4_16 >= 0; l_pos_4_16--) {
      OrderSelect(l_pos_4_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) l_count_0_16++;
   }
   return (l_count_0_16);
}

void CloseThisSymbolAll_16() {
   for (int l_pos_0_16 = OrdersTotal() - 1; l_pos_0_16 >= 0; l_pos_0_16--) {
      OrderSelect(l_pos_0_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, slip_16, Blue);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, slip_16, Red);
         }
         Sleep(1000);
      }
   }
}

int OpenPendingOrder_16(int ai_0_16, double a_lots_4_16, double a_price_12_16, int a_slippage_20_16, double ad_24_16, int ai_32_16, int ai_36_16, string a_comment_40_16, int a_magic_48_16, int a_datetime_52_16, color a_color_56_16) {
   int l_ticket_60_16 = 0;
   int l_error_64_16 = 0;
   int l_count_68_16 = 0;
   int li_72_16 = 100;
   switch (ai_0_16) {
   case 0:
      for (l_count_68_16 = 0; l_count_68_16 < li_72_16; l_count_68_16++) {
         RefreshRates();
         l_ticket_60_16 = OrderSend(Symbol(), OP_BUY, a_lots_4_16, NormalizeDouble(Ask,Digits), a_slippage_20_16, NormalizeDouble(StopLong_16(Bid, ai_32_16),Digits), NormalizeDouble(TakeLong_16(Ask, ai_36_16),Digits), a_comment_40_16, a_magic_48_16, a_datetime_52_16, a_color_56_16);
         l_error_64_16 = GetLastError();
         if (l_error_64_16 == 0/* NO_ERROR */) break;
         if (!(l_error_64_16 == 4/* SERVER_BUSY */ || l_error_64_16 == 137/* BROKER_BUSY */ || l_error_64_16 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64_16 == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (l_count_68_16 = 0; l_count_68_16 < li_72_16; l_count_68_16++) {
         l_ticket_60_16 = OrderSend(Symbol(), OP_SELL, a_lots_4_16, NormalizeDouble(Bid,Digits), a_slippage_20_16, NormalizeDouble(StopShort_16(Ask, ai_32_16),Digits), NormalizeDouble(TakeShort_16(Bid, ai_36_16),Digits), a_comment_40_16, a_magic_48_16, a_datetime_52_16, a_color_56_16);
         l_error_64_16 = GetLastError();
         if (l_error_64_16 == 0/* NO_ERROR */) break;
         if (!(l_error_64_16 == 4/* SERVER_BUSY */ || l_error_64_16 == 137/* BROKER_BUSY */ || l_error_64_16 == 146/* TRADE_CONTEXT_BUSY */ || l_error_64_16 == 136/* OFF_QUOTES */)) break;
         Sleep(5000);
      }
   }
   return (l_ticket_60_16);
}

double StopLong_16(double ad_0_16, int ai_8_16) {
   if (ai_8_16 == 0) return (0);
   else return (ad_0_16 - ai_8_16 * Point);
}

double StopShort_16(double ad_0_16, int ai_8_16) {
   if (ai_8_16 == 0) return (0);
   else return (ad_0_16 + ai_8_16 * Point);
}

double TakeLong_16(double ad_0_16, int ai_8_16) {
   if (ai_8_16 == 0) return (0);
   else return (ad_0_16 + ai_8_16 * Point);
}

double TakeShort_16(double ad_0_16, int ai_8_16) {
   if (ai_8_16 == 0) return (0);
   else return (ad_0_16 - ai_8_16 * Point);
}

double CalculateProfit_16() {
   double ld_ret_0_16 = 0;
   for (g_pos_300_16 = OrdersTotal() - 1; g_pos_300_16 >= 0; g_pos_300_16--) {
      OrderSelect(g_pos_300_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) ld_ret_0_16 += OrderProfit();
   }
   return (ld_ret_0_16);
}

void TrailingAlls_16(int ai_0_16, int ai_4_16, double a_price_8_16) {
   int l_ticket_16_16;
   double l_ord_stoploss_20_16;
   double l_price_28_16;
   if (ai_4_16 != 0) {
      for (int l_pos_36 = OrdersTotal() - 1; l_pos_36 >= 0; l_pos_36--) {
         if (OrderSelect(l_pos_36, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == g_magic_176_16) {
               if (OrderType() == OP_BUY) {
                  l_ticket_16_16 = NormalizeDouble((Bid - a_price_8_16) / Point, 0);
                  if (l_ticket_16_16 < ai_0_16) continue;
                  l_ord_stoploss_20_16 = OrderStopLoss();
                  l_price_28_16 = Bid - ai_4_16 * Point;
                  if (l_ord_stoploss_20_16 == 0.0 || (l_ord_stoploss_20_16 != 0.0 && l_price_28_16 > l_ord_stoploss_20_16)) OrderModify(OrderTicket(), a_price_8_16, l_price_28_16, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  l_ticket_16_16 = NormalizeDouble((a_price_8_16 - Ask) / Point, 0);
                  if (l_ticket_16_16 < ai_0_16) continue;
                  l_ord_stoploss_20_16 = OrderStopLoss();
                  l_price_28_16 = Ask + ai_4_16 * Point;
                  if (l_ord_stoploss_20_16 == 0.0 || (l_ord_stoploss_20_16 != 0.0 && l_price_28_16 < l_ord_stoploss_20_16)) OrderModify(OrderTicket(), a_price_8_16, l_price_28_16, OrderTakeProfit(), 0, Red);
               }
            }
            Sleep(1000);
         }
      }
   }
}

double CountTotalLots() {
   double d_countlot = 0;
   for (int l_pos_4_15 = OrdersTotal() - 1; l_pos_4_15 >= 0; l_pos_4_15--) {
      OrderSelect(l_pos_4_15, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() == OP_SELL || OrderType() == OP_BUY) d_countlot+=OrderLots();
   }
   return (d_countlot);
}

double AccountEquityHigh_16() {
   if (CountTrades_16() == 0) gd_336_16 = AccountEquity();
   if (gd_336_16 < gd_344_16) gd_336_16 = gd_344_16;
   else gd_336_16 = AccountEquity();
   gd_344_16 = AccountEquity();
   return (gd_336_16);
}

double FindLastBuyPrice_16() {
   double l_ord_open_price_8_16;
   int l_ticket_24_16;
   double ld_unused_0_16 = 0;
   int l_ticket_20_16 = 0;
   for (int l_pos_16_16 = OrdersTotal() - 1; l_pos_16_16 >= 0; l_pos_16_16--) {
      OrderSelect(l_pos_16_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16 && OrderType() == OP_BUY) {
         l_ticket_24_16 = OrderTicket();
         if (l_ticket_24_16 > l_ticket_20_16) {
            l_ord_open_price_8_16 = OrderOpenPrice();
            ld_unused_0_16 = l_ord_open_price_8_16;
            l_ticket_20_16 = l_ticket_24_16;
         }
      }
   }
   return (l_ord_open_price_8_16);
}

double FindLastSellPrice_16() {
   double l_ord_open_price_8_16;
   int l_ticket_24_16;
   double ld_unused_0_16 = 0;
   int l_ticket_20_16 = 0;
   for (int l_pos_16_16 = OrdersTotal() - 1; l_pos_16_16 >= 0; l_pos_16_16--) {
      OrderSelect(l_pos_16_16, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != g_magic_176_16) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_176_16 && OrderType() == OP_SELL) {
         l_ticket_24_16 = OrderTicket();
         if (l_ticket_24_16 > l_ticket_20_16) {
            l_ord_open_price_8_16 = OrderOpenPrice();
            ld_unused_0_16 = l_ord_open_price_8_16;
            l_ticket_20_16 = l_ticket_24_16;
         }
      }
   }
   return (l_ord_open_price_8_16);
}//  
//----------------------------------  END oF ilan 1.6