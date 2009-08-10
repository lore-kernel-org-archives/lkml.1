Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZHJMCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZHJMCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZHJMCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:02:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54907 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbZHJMC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:02:29 -0400
Subject: [BUILD FAIL] Linus git Tree on x86_32 for randconfig dated
	10/08/2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       balbir <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Mon, 10 Aug 2009 17:32:08 +0530
Message-Id: <1249905728.5187.21.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg/Ingo,

Todayś Linus git tree produced the following build failure on
randconfig:

.....
.....
(.text+0xf280): multiple definition of `CmmRxnonRalinkFrameIndicate'
drivers/staging/rt2860/built-in.o:(.text+0x12d3f): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMPEnableRxTx':
(.text+0xff8b): multiple definition of `RTMPEnableRxTx'
drivers/staging/rt2860/built-in.o:(.text+0x14c0f): first defined here
ld: Warning: size of symbol `RTMPEnableRxTx' changed from 181 in
drivers/staging/rt2860/built-in.o to 137 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o: In function `Set_SSID_Proc':
(.text+0x37bb6): multiple definition of `Set_SSID_Proc'
drivers/staging/rt2860/built-in.o:(.text+0x44111): first defined here
ld: Warning: size of symbol `Set_SSID_Proc' changed from 278 in
drivers/staging/rt2860/built-in.o to 338 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o: In function `BA_MaxWinSizeReasign':
(.text+0x3f1a0): multiple definition of `BA_MaxWinSizeReasign'
drivers/staging/rt2860/built-in.o:(.text+0x4aec4): first defined here
drivers/staging/rt2870/built-in.o:(.data+0x483): multiple definition of
`TimIe'
drivers/staging/rt2860/built-in.o:(.data+0x483): first defined here
drivers/staging/rt2870/built-in.o: In function `MlmeADDBAAction':
(.text+0xd0ec): multiple definition of `MlmeADDBAAction'
drivers/staging/rt2860/built-in.o:(.text+0x10670): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMPSoftDecryptWEP':
(.text+0xc54a): multiple definition of `RTMPSoftDecryptWEP'
drivers/staging/rt2860/built-in.o:(.text+0xface): first defined here
drivers/staging/rt2870/built-in.o: In function `BssTableSearchWithSSID':
(.text+0x9cef): multiple definition of `BssTableSearchWithSSID'
drivers/staging/rt2860/built-in.o:(.text+0xcf77): first defined here
drivers/staging/rt2870/built-in.o: In function `Show_HtGi_Proc':
(.text+0x17eab): multiple definition of `Show_HtGi_Proc'
drivers/staging/rt2860/built-in.o:(.text+0x1f12d): first defined here
drivers/staging/rt2870/built-in.o: In function `STAHandleRxDataFrame':
(.text+0x28d5e): multiple definition of `STAHandleRxDataFrame'
drivers/staging/rt2860/built-in.o:(.text+0x31713): first defined here
ld: Warning: size of symbol `STAHandleRxDataFrame' changed from 970 in
drivers/staging/rt2860/built-in.o to 967 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o: In function
`linux_BAOriSessionSetupTimeout':
(.text+0x40f5d): multiple definition of `linux_BAOriSessionSetupTimeout'
drivers/staging/rt2860/built-in.o:(.text+0x4cc93): first defined here
ld: Warning: size of symbol `linux_BAOriSessionSetupTimeout' changed
from 70 in drivers/staging/rt2860/built-in.o to 84 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o: In function
`AironetCreateBeaconReportFromBssTable':
(.text+0x21994): multiple definition of
`AironetCreateBeaconReportFromBssTable'
drivers/staging/rt2860/built-in.o:(.text+0x2940c): first defined here
drivers/staging/rt2870/built-in.o:(.data+0x3bf0): multiple definition of
`CipherSuiteCCXTkipLen'
drivers/staging/rt2860/built-in.o:(.data+0x3bb8): first defined here
drivers/staging/rt2870/built-in.o: In function `NICInitAsicFromEEPROM':
(.text+0x11110): multiple definition of `NICInitAsicFromEEPROM'
drivers/staging/rt2860/built-in.o:(.text+0x18483): first defined here
ld: Warning: size of symbol `NICInitAsicFromEEPROM' changed from 2136 in
drivers/staging/rt2860/built-in.o to 697 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o: In function `rt_ioctl_siwsens':
(.text+0x348b1): multiple definition of `rt_ioctl_siwsens'
drivers/staging/rt2860/built-in.o:(.text+0x3f7bd): first defined here
drivers/staging/rt2870/built-in.o: In function `AsicSwitchChannel':
(.text+0x7903): multiple definition of `AsicSwitchChannel'
drivers/staging/rt2860/built-in.o:(.text+0x8ac6): first defined here
ld: Warning: size of symbol `AsicSwitchChannel' changed from 6904 in
drivers/staging/rt2860/built-in.o to 2095 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o:(.data+0x3ae0): multiple definition of
`OUI_WPA2_WEP40'
drivers/staging/rt2860/built-in.o:(.data+0x3aa8): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMPSetPiggyBack':
(.text+0x4eb3): multiple definition of `RTMPSetPiggyBack'
drivers/staging/rt2860/built-in.o:(.text+0x3e07): first defined here
ld: Warning: size of symbol `RTMPSetPiggyBack' changed from 103 in
drivers/staging/rt2860/built-in.o to 93 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o: In function `RTMPTkipAppend':
(.text+0x13b2d): multiple definition of `RTMPTkipAppend'
drivers/staging/rt2860/built-in.o:(.text+0x1aac9): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMPInitWepEngine':
(.text+0xc659): multiple definition of `RTMPInitWepEngine'
drivers/staging/rt2860/built-in.o:(.text+0xfbdd): first defined here
drivers/staging/rt2870/built-in.o:(.data+0x390c): multiple definition of
`A_BAND_REGION_0_CHANNEL_LIST'
drivers/staging/rt2860/built-in.o:(.data+0x38d4): first defined here
drivers/staging/rt2870/built-in.o: In function `Set_HtGi_Proc':
(.text+0x1ac8c): multiple definition of `Set_HtGi_Proc'
drivers/staging/rt2860/built-in.o:(.text+0x225a4): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMPSetLED':
(.text+0x100ef): multiple definition of `RTMPSetLED'
drivers/staging/rt2860/built-in.o:(.text+0x14d59): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMPSetPhyMode':
(.text+0x1aef6): multiple definition of `RTMPSetPhyMode'
drivers/staging/rt2860/built-in.o:(.text+0x2280e): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMPSendRTSFrame':
(.text+0x26e64): multiple definition of `RTMPSendRTSFrame'
drivers/staging/rt2860/built-in.o:(.text+0x2f704): first defined here
drivers/staging/rt2870/built-in.o: In function `STA_AMPDU_Frame_Tx':
(.text+0x27e25): multiple definition of `STA_AMPDU_Frame_Tx'
drivers/staging/rt2860/built-in.o:(.text+0x30807): first defined here
ld: Warning: size of symbol `STA_AMPDU_Frame_Tx' changed from 685 in
drivers/staging/rt2860/built-in.o to 644 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o:(.data+0x208): multiple definition of
`RateSwitchTable11N2SForABand'
drivers/staging/rt2860/built-in.o:(.data+0x208): first defined here
drivers/staging/rt2870/built-in.o:(.data+0xe14): multiple definition of
`MapUserPriorityToAccessCategory'
drivers/staging/rt2860/built-in.o:(.data+0xe14): first defined here
drivers/staging/rt2870/built-in.o: In function `F':
(.text+0x2c3a): multiple definition of `F'
drivers/staging/rt2860/built-in.o:(.text+0x2c3a): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMP_QueryPacketInfo':
(.text+0x2f248): multiple definition of `RTMP_QueryPacketInfo'
drivers/staging/rt2860/built-in.o:(.text+0x3a164): first defined here
drivers/staging/rt2870/built-in.o: In function `Set_HtProtect_Proc':
(.text+0x18695): multiple definition of `Set_HtProtect_Proc'
drivers/staging/rt2860/built-in.o:(.text+0x1fa3e): first defined here
drivers/staging/rt2870/built-in.o: In function `CntlIdleProc':
(.text+0x2c6bb): multiple definition of `CntlIdleProc'
drivers/staging/rt2860/built-in.o:(.text+0x37615): first defined here
drivers/staging/rt2870/built-in.o: In function `STAMlmePeriodicExec':
(.text+0xb45b): multiple definition of `STAMlmePeriodicExec'
drivers/staging/rt2860/built-in.o:(.text+0xe9ec): first defined here
ld: Warning: size of symbol `STAMlmePeriodicExec' changed from 1732 in
drivers/staging/rt2860/built-in.o to 1449 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o:(.data+0xf): multiple definition of
`WAPI_OUI'
drivers/staging/rt2860/built-in.o:(.data+0xf): first defined here
drivers/staging/rt2870/built-in.o: In function `RTMPSoftDecryptAES':
(.text+0x14a53): multiple definition of `RTMPSoftDecryptAES'
drivers/staging/rt2860/built-in.o:(.text+0x1b9ef): first defined here
drivers/staging/rt2870/built-in.o: In function
`AsicUpdateWCIDAttribute':
(.text+0x501d): multiple definition of `AsicUpdateWCIDAttribute'
drivers/staging/rt2860/built-in.o:(.text+0x3b8d): first defined here
ld: Warning: size of symbol `AsicUpdateWCIDAttribute' changed from 102
in drivers/staging/rt2860/built-in.o to 82 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o: In function
`ba_reordering_mpdu_insertsorted':
(.text+0x3ee24): multiple definition of
`ba_reordering_mpdu_insertsorted'
drivers/staging/rt2860/built-in.o:(.text+0x4ab48): first defined here
drivers/staging/rt2870/built-in.o: In function `Show_HtMcs_Proc':
(.text+0x17eef): multiple definition of `Show_HtMcs_Proc'
drivers/staging/rt2860/built-in.o:(.text+0x1f171): first defined here
drivers/staging/rt2870/built-in.o: In function
`deaggregate_AMSDU_announce':
(.text+0xeff9): multiple definition of `deaggregate_AMSDU_announce'
drivers/staging/rt2860/built-in.o:(.text+0x12ab8): first defined here
drivers/staging/rt2870/built-in.o: In function
`RTMPGetRalinkEncryModeStr':
(.text+0x179a8): multiple definition of `RTMPGetRalinkEncryModeStr'
drivers/staging/rt2860/built-in.o:(.text+0x1ec2a): first defined here
drivers/staging/rt2870/built-in.o: In function `BASessionTearDownALL':
(.text+0x406ad): multiple definition of `BASessionTearDownALL'
drivers/staging/rt2860/built-in.o:(.text+0x4c3d8): first defined here
drivers/staging/rt2870/built-in.o: In function `NICInitializeAdapter':
(.text+0x11929): multiple definition of `NICInitializeAdapter'
drivers/staging/rt2860/built-in.o:(.text+0x15b1a): first defined here
ld: Warning: size of symbol `NICInitializeAdapter' changed from 1374 in
drivers/staging/rt2860/built-in.o to 356 in
drivers/staging/rt2870/built-in.o
drivers/staging/rt2870/built-in.o: In function `BATableAllocOriEntry':
(.text+0x3ef69): multiple definition of `BATableAllocOriEntry'
drivers/staging/rt2860/built-in.o:(.text+0x4ac8d): first defined here
drivers/staging/rt2870/built-in.o: In function `MlmeReassocReqAction':
(.text+0x20a42): multiple definition of `MlmeReassocReqAction'
drivers/staging/rt2860/built-in.o:(.text+0x284e8): first defined here
drivers/staging/rt2870/built-in.o: In function `rt_ioctl_giwauth':
(.text+0x34321): multiple definition of `rt_ioctl_giwauth'
drivers/staging/rt2860/built-in.o:(.text+0x3f22d): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_sta_ps_sleep':
(.text+0x20f00): multiple definition of `ieee80211_sta_ps_sleep'
drivers/staging/rtl8187se/built-in.o:(.text+0x19a8d): first defined here
ld: Warning: size of symbol `ieee80211_sta_ps_sleep' changed from 264 in
drivers/staging/rtl8187se/built-in.o to 292 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_sta_ps_send_null_frame':
(.text+0x21b20): multiple definition of
`ieee80211_sta_ps_send_null_frame'
drivers/staging/rtl8187se/built-in.o:(.text+0x17d2a): first defined here
ld: Warning: size of symbol `ieee80211_sta_ps_send_null_frame' changed
from 62 in drivers/staging/rtl8187se/built-in.o to 256 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_wx_sync_scan_wq':
(.text+0x28f10): multiple definition of `ieee80211_wx_sync_scan_wq'
drivers/staging/rtl8187se/built-in.o:(.text+0x1eeb6): first defined here
ld: Warning: size of symbol `ieee80211_wx_sync_scan_wq' changed from 223
in drivers/staging/rtl8187se/built-in.o to 617 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_send_beacon':
(.text+0x24380): multiple definition of `ieee80211_send_beacon'
drivers/staging/rtl8187se/built-in.o:(.text+0x19e5b): first defined here
ld: Warning: size of symbol `ieee80211_send_beacon' changed from 127 in
drivers/staging/rtl8187se/built-in.o to 626 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `ieee80211_probe_req':
(.text+0x1ec80): multiple definition of `ieee80211_probe_req'
drivers/staging/rtl8187se/built-in.o:(.text+0x181cc): first defined here
ld: Warning: size of symbol `ieee80211_probe_req' changed from 264 in
drivers/staging/rtl8187se/built-in.o to 303 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_softmac_stop_scan':
(.text+0x1edb0): multiple definition of `ieee80211_softmac_stop_scan'
drivers/staging/rtl8187se/built-in.o:(.text+0x170f8): first defined here
ld: Warning: size of symbol `ieee80211_softmac_stop_scan' changed from
93 in drivers/staging/rtl8187se/built-in.o to 119 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_resp_to_probe':
(.text+0x23940): multiple definition of `ieee80211_resp_to_probe'
drivers/staging/rtl8187se/built-in.o:(.text+0x187dc): first defined here
ld: Warning: size of symbol `ieee80211_resp_to_probe' changed from 70 in
drivers/staging/rtl8187se/built-in.o to 511 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_softmac_new_net':
(.text+0x21030): multiple definition of `ieee80211_softmac_new_net'
drivers/staging/rtl8187se/built-in.o:(.text+0x194dc): first defined here
ld: Warning: size of symbol `ieee80211_softmac_new_net' changed from 639
in drivers/staging/rtl8187se/built-in.o to 922 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `ieeerate2rtlrate':
(.text+0xe680): multiple definition of `ieeerate2rtlrate'
drivers/staging/rtl8187se/built-in.o:(.text+0x26d): first defined here
ld: Warning: size of symbol `ieeerate2rtlrate' changed from 150 in
drivers/staging/rtl8187se/built-in.o to 335 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `IsLegalChannel':
(.text+0x2e290): multiple definition of `IsLegalChannel'
drivers/staging/rtl8187se/built-in.o:(.text+0x165d7): first defined here
ld: Warning: size of symbol `IsLegalChannel' changed from 80 in
drivers/staging/rtl8187se/built-in.o to 85 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_softmac_free':
(.text+0x21980): multiple definition of `ieee80211_softmac_free'
drivers/staging/rtl8187se/built-in.o:(.text+0x17235): first defined here
ld: Warning: size of symbol `ieee80211_softmac_free' changed from 122 in
drivers/staging/rtl8187se/built-in.o to 133 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_send_beacon_cb':
(.text+0x24920): multiple definition of `ieee80211_send_beacon_cb'
drivers/staging/rtl8187se/built-in.o:(.text+0x19f76): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`Dot11d_UpdateCountryIe':
(.text+0x2e3e0): multiple definition of `Dot11d_UpdateCountryIe'
drivers/staging/rtl8187se/built-in.o:(.text+0x16766): first defined here
ld: Warning: size of symbol `Dot11d_UpdateCountryIe' changed from 719 in
drivers/staging/rtl8187se/built-in.o to 587 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_softmac_init':
(.text+0x1ef30): multiple definition of `ieee80211_softmac_init'
drivers/staging/rtl8187se/built-in.o:(.text+0x172af): first defined here
ld: Warning: size of symbol `ieee80211_softmac_init' changed from 832 in
drivers/staging/rtl8187se/built-in.o to 1001 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `assoc_rq_parse':
(.text+0x1e360): multiple definition of `assoc_rq_parse'
drivers/staging/rtl8187se/built-in.o:(.text+0x16df7): first defined here
ld: Warning: size of symbol `assoc_rq_parse' changed from 69 in
drivers/staging/rtl8187se/built-in.o to 103 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_associate_step2':
(.text+0x22980): multiple definition of `ieee80211_associate_step2'
drivers/staging/rtl8187se/built-in.o:(.text+0x19cd4): first defined here
ld: Warning: size of symbol `ieee80211_associate_step2' changed from 125
in drivers/staging/rtl8187se/built-in.o to 610 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_associate_complete':
(.text+0x20d30): multiple definition of `ieee80211_associate_complete'
drivers/staging/rtl8187se/built-in.o:(.text+0x1948d): first defined here
drivers/staging/rtl8192su/built-in.o: In function `ieee80211_start_bss':
(.text+0x21570): multiple definition of `ieee80211_start_bss'
drivers/staging/rtl8187se/built-in.o:(.text+0x198c0): first defined here
ld: Warning: size of symbol `ieee80211_start_bss' changed from 126 in
drivers/staging/rtl8187se/built-in.o to 155 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `write_nic_word':
(.text+0x13e90): multiple definition of `write_nic_word'
drivers/staging/rtl8187se/built-in.o:(.text+0xe7c): first defined here
ld: Warning: size of symbol `write_nic_word' changed from 56 in
drivers/staging/rtl8187se/built-in.o to 115 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `eprom_read':
(.text+0x260): multiple definition of `eprom_read'
drivers/staging/rtl8187se/built-in.o:(.text+0x67dc): first defined here
ld: Warning: size of symbol `eprom_read' changed from 368 in
drivers/staging/rtl8187se/built-in.o to 392 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_MFIE_Brate':
(.text+0x1dee0): multiple definition of `ieee80211_MFIE_Brate'
drivers/staging/rtl8187se/built-in.o:(.text+0x16b1a): first defined here
drivers/staging/rtl8192su/built-in.o: In function `ieee80211_WMM_Info':
(.text+0x1df90): multiple definition of `ieee80211_WMM_Info'
drivers/staging/rtl8187se/built-in.o:(.text+0x16bc2): first defined here
drivers/staging/rtl8192su/built-in.o: In function `Dot11d_Reset':
(.text+0x2e070): multiple definition of `Dot11d_Reset'
drivers/staging/rtl8187se/built-in.o:(.text+0x16410): first defined here
ld: Warning: size of symbol `Dot11d_Reset' changed from 152 in
drivers/staging/rtl8187se/built-in.o to 167 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_start_master_bss':
(.text+0x200e0): multiple definition of `ieee80211_start_master_bss'
drivers/staging/rtl8187se/built-in.o:(.text+0x186d0): first defined here
ld: Warning: size of symbol `ieee80211_start_master_bss' changed from
193 in drivers/staging/rtl8187se/built-in.o to 200 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `ieee80211_auth_resp':
(.text+0x1e7e0): multiple definition of `ieee80211_auth_resp'
drivers/staging/rtl8187se/built-in.o:(.text+0x175ef): first defined here
ld: Warning: size of symbol `ieee80211_auth_resp' changed from 149 in
drivers/staging/rtl8187se/built-in.o to 156 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`eprom_send_bits_string':
(.text+0x160): multiple definition of `eprom_send_bits_string'
drivers/staging/rtl8187se/built-in.o:(.text+0x6718): first defined here
ld: Warning: size of symbol `eprom_send_bits_string' changed from 81 in
drivers/staging/rtl8187se/built-in.o to 97 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`softmac_ps_mgmt_xmit':
(.text+0x1e170): multiple definition of `softmac_ps_mgmt_xmit'
drivers/staging/rtl8187se/built-in.o:(.text+0x16ce7): first defined here
ld: Warning: size of symbol `softmac_ps_mgmt_xmit' changed from 193 in
drivers/staging/rtl8187se/built-in.o to 240 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `ieee80211_alloc_txb':
(.text+0x25080): multiple definition of `ieee80211_alloc_txb'
drivers/staging/rtl8187se/built-in.o:(.text+0x1c8d2): first defined here
ld: Warning: size of symbol `ieee80211_alloc_txb' changed from 165 in
drivers/staging/rtl8187se/built-in.o to 201 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_associate_procedure_wq':
(.text+0x22550): multiple definition of
`ieee80211_associate_procedure_wq'
drivers/staging/rtl8187se/built-in.o:(.text+0x19dcf): first defined here
ld: Warning: size of symbol `ieee80211_associate_procedure_wq' changed
from 140 in drivers/staging/rtl8187se/built-in.o to 161 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `ieee80211_sta_ps':
(.text+0x22070): multiple definition of `ieee80211_sta_ps'
drivers/staging/rtl8187se/built-in.o:(.text+0x19b95): first defined here
ld: Warning: size of symbol `ieee80211_sta_ps' changed from 319 in
drivers/staging/rtl8187se/built-in.o to 392 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `Dot11d_Init':
(.text+0x2e350): multiple definition of `Dot11d_Init'
drivers/staging/rtl8187se/built-in.o:(.text+0x166e6): first defined here
ld: Warning: size of symbol `Dot11d_Init' changed from 128 in
drivers/staging/rtl8187se/built-in.o to 130 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `read_nic_dword':
(.text+0x12560): multiple definition of `read_nic_dword'
drivers/staging/rtl8187se/built-in.o:(.text+0x2a): first defined here
ld: Warning: size of symbol `read_nic_dword' changed from 42 in
drivers/staging/rtl8187se/built-in.o to 137 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `eprom_cs':
(.text+0x1d0): multiple definition of `eprom_cs'
drivers/staging/rtl8187se/built-in.o:(.text+0x6769): first defined here
ld: Warning: size of symbol `eprom_cs' changed from 115 in
drivers/staging/rtl8187se/built-in.o to 134 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_beacons_start':
(.text+0x24600): multiple definition of `ieee80211_beacons_start'
drivers/staging/rtl8187se/built-in.o:(.text+0x19eda): first defined here
drivers/staging/rtl8192su/built-in.o: In function `ComputeTxTime':
(.text+0xed70): multiple definition of `ComputeTxTime'
drivers/staging/rtl8187se/built-in.o:(.text+0x3ea): first defined here
ld: Warning: size of symbol `ComputeTxTime' changed from 252 in
drivers/staging/rtl8187se/built-in.o to 299 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_assoc_resp':
(.text+0x1e9c0): multiple definition of `ieee80211_assoc_resp'
drivers/staging/rtl8187se/built-in.o:(.text+0x17fc1): first defined here
ld: Warning: size of symbol `ieee80211_assoc_resp' changed from 336 in
drivers/staging/rtl8187se/built-in.o to 400 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_auth_challenge':
(.text+0x22600): multiple definition of `ieee80211_auth_challenge'
drivers/staging/rtl8187se/built-in.o:(.text+0x1a041): first defined here
ld: Warning: size of symbol `ieee80211_auth_challenge' changed from 234
in drivers/staging/rtl8187se/built-in.o to 890 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_associate_complete_wq':
(.text+0x21760): multiple definition of
`ieee80211_associate_complete_wq'
drivers/staging/rtl8187se/built-in.o:(.text+0x185d9): first defined here
ld: Warning: size of symbol `ieee80211_associate_complete_wq' changed
from 247 in drivers/staging/rtl8187se/built-in.o to 538 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_associate_retry_wq':
(.text+0x214a0): multiple definition of `ieee80211_associate_retry_wq'
drivers/staging/rtl8187se/built-in.o:(.text+0x19805): first defined here
ld: Warning: size of symbol `ieee80211_associate_retry_wq' changed from
187 in drivers/staging/rtl8187se/built-in.o to 203 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_associate_step1':
(.text+0x22200): multiple definition of `ieee80211_associate_step1'
drivers/staging/rtl8187se/built-in.o:(.text+0x19d51): first defined here
ld: Warning: size of symbol `ieee80211_associate_step1' changed from 126
in drivers/staging/rtl8187se/built-in.o to 839 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `print_buffer':
(.text+0xfd70): multiple definition of `print_buffer'
drivers/staging/rtl8187se/built-in.o:(.text+0xd01): first defined here
ld: Warning: size of symbol `print_buffer' changed from 134 in
drivers/staging/rtl8187se/built-in.o to 154 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `auth_rq_parse':
(.text+0x1e3d0): multiple definition of `auth_rq_parse'
drivers/staging/rtl8187se/built-in.o:(.text+0x16da8): first defined here
ld: Warning: size of symbol `auth_rq_parse' changed from 79 in
drivers/staging/rtl8187se/built-in.o to 119 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `dequeue_mgmt':
(.text+0x1e040): multiple definition of `dequeue_mgmt'
drivers/staging/rtl8187se/built-in.o:(.text+0x16c59): first defined here
ld: Warning: size of symbol `dequeue_mgmt' changed from 85 in
drivers/staging/rtl8187se/built-in.o to 105 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o:(.data+0x121e0): multiple
definition of `rsn_authen_cipher_suite'
drivers/staging/rtl8187se/built-in.o:(.data+0x720): first defined here
drivers/staging/rtl8192su/built-in.o: In function `ieee80211_null_func':
(.text+0x1e920): multiple definition of `ieee80211_null_func'
drivers/staging/rtl8187se/built-in.o:(.text+0x17c93): first defined here
ld: Warning: size of symbol `ieee80211_null_func' changed from 151 in
drivers/staging/rtl8187se/built-in.o to 156 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`DOT11D_GetMaxTxPwrInDbm':
(.text+0x2e2f0): multiple definition of `DOT11D_GetMaxTxPwrInDbm'
drivers/staging/rtl8187se/built-in.o:(.text+0x16627): first defined here
ld: Warning: size of symbol `DOT11D_GetMaxTxPwrInDbm' changed from 85 in
drivers/staging/rtl8187se/built-in.o to 93 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_randomize_cell':
(.text+0x201b0): multiple definition of `ieee80211_randomize_cell'
drivers/staging/rtl8187se/built-in.o:(.text+0x18791): first defined here
drivers/staging/rtl8192su/built-in.o: In function `dump_eprom':
(.text+0x10bb0): multiple definition of `dump_eprom'
drivers/staging/rtl8187se/built-in.o:(.text+0x2c71): first defined here
ld: Warning: size of symbol `dump_eprom' changed from 77 in
drivers/staging/rtl8187se/built-in.o to 97 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_associate_abort_cb':
(.text+0x1ffc0): multiple definition of `ieee80211_associate_abort_cb'
drivers/staging/rtl8187se/built-in.o:(.text+0x184ef): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_start_monitor_mode':
(.text+0x20090): multiple definition of `ieee80211_start_monitor_mode'
drivers/staging/rtl8187se/built-in.o:(.text+0x18591): first defined here
drivers/staging/rtl8192su/built-in.o: In function `write_nic_dword':
(.text+0x13600): multiple definition of `write_nic_dword'
drivers/staging/rtl8187se/built-in.o:(.text+0xf24): first defined here
ld: Warning: size of symbol `write_nic_dword' changed from 55 in
drivers/staging/rtl8187se/built-in.o to 114 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_disassociate_skb':
(.text+0x1e880): multiple definition of `ieee80211_disassociate_skb'
drivers/staging/rtl8187se/built-in.o:(.text+0x1835f): first defined here
ld: Warning: size of symbol `ieee80211_disassociate_skb' changed from
142 in drivers/staging/rtl8187se/built-in.o to 148 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_wpa_assoc_frame':
(.text+0x20310): multiple definition of `ieee80211_wpa_assoc_frame'
drivers/staging/rtl8187se/built-in.o:(.text+0x18a77): first defined here
ld: Warning: size of symbol `ieee80211_wpa_assoc_frame' changed from 76
in drivers/staging/rtl8187se/built-in.o to 96 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `N_DBPSOfRate':
(.text+0xeca0): multiple definition of `N_DBPSOfRate'
drivers/staging/rtl8187se/built-in.o:(.text+0x37d): first defined here
ld: Warning: size of symbol `N_DBPSOfRate' changed from 109 in
drivers/staging/rtl8187se/built-in.o to 207 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_encrypt_fragment':
(.text+0x24d20): multiple definition of `ieee80211_encrypt_fragment'
drivers/staging/rtl8187se/built-in.o:(.text+0x1c7d0): first defined here
ld: Warning: size of symbol `ieee80211_encrypt_fragment' changed from
179 in drivers/staging/rtl8187se/built-in.o to 207 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_authentication_req':
(.text+0x1eb50): multiple definition of `ieee80211_authentication_req'
drivers/staging/rtl8187se/built-in.o:(.text+0x18111): first defined here
ld: Warning: size of symbol `ieee80211_authentication_req' changed from
187 in drivers/staging/rtl8187se/built-in.o to 289 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_MFIE_rate_len':
(.text+0x1dea0): multiple definition of `ieee80211_MFIE_rate_len'
drivers/staging/rtl8187se/built-in.o:(.text+0x16add): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_sta_wakeup':
(.text+0x21ce0): multiple definition of `ieee80211_sta_wakeup'
drivers/staging/rtl8187se/built-in.o:(.text+0x17e10): first defined here
ld: Warning: size of symbol `ieee80211_sta_wakeup' changed from 99 in
drivers/staging/rtl8187se/built-in.o to 156 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_ccmp_aes_encrypt':
(.text+0x2fec0): multiple definition of `ieee80211_ccmp_aes_encrypt'
drivers/staging/rtl8187se/built-in.o:(.text+0x207ec): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_softmac_check_all_nets':
(.text+0x213d0): multiple definition of
`ieee80211_softmac_check_all_nets'
drivers/staging/rtl8187se/built-in.o:(.text+0x1975b): first defined here
ld: Warning: size of symbol `ieee80211_softmac_check_all_nets' changed
from 170 in drivers/staging/rtl8187se/built-in.o to 196 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_associate_abort':
(.text+0x1ff00): multiple definition of `ieee80211_associate_abort'
drivers/staging/rtl8187se/built-in.o:(.text+0x1846c): first defined here
ld: Warning: size of symbol `ieee80211_associate_abort' changed from 131
in drivers/staging/rtl8187se/built-in.o to 192 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `ToLegalChannel':
(.text+0x2e210): multiple definition of `ToLegalChannel'
drivers/staging/rtl8187se/built-in.o:(.text+0x16569): first defined here
ld: Warning: size of symbol `ToLegalChannel' changed from 110 in
drivers/staging/rtl8187se/built-in.o to 122 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o:(.data+0x0): multiple definition of
`rtl8180_rates'
drivers/staging/rtl8187se/built-in.o:(.data+0x164): first defined here
drivers/staging/rtl8192su/built-in.o: In function `force_pci_posting':
(.text+0xe500): multiple definition of `force_pci_posting'
drivers/staging/rtl8187se/built-in.o:(.text+0x7f): first defined here
ld: Warning: size of symbol `force_pci_posting' changed from 48 in
drivers/staging/rtl8187se/built-in.o to 36 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `write_nic_byte':
(.text+0x13f10): multiple definition of `write_nic_byte'
drivers/staging/rtl8187se/built-in.o:(.text+0x12e0): first defined here
ld: Warning: size of symbol `write_nic_byte' changed from 55 in
drivers/staging/rtl8187se/built-in.o to 114 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_association_req':
(.text+0x1f8b0): multiple definition of `ieee80211_association_req'
drivers/staging/rtl8187se/built-in.o:(.text+0x17a7f): first defined here
ld: Warning: size of symbol `ieee80211_association_req' changed from 532
in drivers/staging/rtl8187se/built-in.o to 1544 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `eprom_ck_cycle':
(.text+0xd0): multiple definition of `eprom_ck_cycle'
drivers/staging/rtl8187se/built-in.o:(.text+0x668f): first defined here
ld: Warning: size of symbol `eprom_ck_cycle' changed from 137 in
drivers/staging/rtl8187se/built-in.o to 138 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `DOT11D_ScanComplete':
(.text+0x2e120): multiple definition of `DOT11D_ScanComplete'
drivers/staging/rtl8187se/built-in.o:(.text+0x164a8): first defined here
ld: Warning: size of symbol `DOT11D_ScanComplete' changed from 193 in
drivers/staging/rtl8187se/built-in.o to 234 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `ieee80211_resume_tx':
(.text+0x20b30): multiple definition of `ieee80211_resume_tx'
drivers/staging/rtl8187se/built-in.o:(.text+0x1922e): first defined here
ld: Warning: size of symbol `ieee80211_resume_tx' changed from 133 in
drivers/staging/rtl8187se/built-in.o to 149 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_start_ibss':
(.text+0x1fec0): multiple definition of `ieee80211_start_ibss'
drivers/staging/rtl8187se/built-in.o:(.text+0x18431): first defined here
drivers/staging/rtl8192su/built-in.o: In function `read_nic_byte':
(.text+0x130f0): multiple definition of `read_nic_byte'
drivers/staging/rtl8187se/built-in.o:(.text+0x0): first defined here
ld: Warning: size of symbol `read_nic_byte' changed from 42 in
drivers/staging/rtl8187se/built-in.o to 117 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_resp_to_assoc_rq':
(.text+0x234e0): multiple definition of `ieee80211_resp_to_assoc_rq'
drivers/staging/rtl8187se/built-in.o:(.text+0x188c1): first defined here
ld: Warning: size of symbol `ieee80211_resp_to_assoc_rq' changed from 70
in drivers/staging/rtl8187se/built-in.o to 511 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_beacons_stop':
(.text+0x1ee80): multiple definition of `ieee80211_beacons_stop'
drivers/staging/rtl8187se/built-in.o:(.text+0x17195): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_MFIE_Grate':
(.text+0x1df30): multiple definition of `ieee80211_MFIE_Grate'
drivers/staging/rtl8187se/built-in.o:(.text+0x16b66): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_TURBO_Info':
(.text+0x1e450): multiple definition of `ieee80211_TURBO_Info'
drivers/staging/rtl8187se/built-in.o:(.text+0x16ef5): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_rx_frame_softmac':
(.text+0x23b40): multiple definition of `ieee80211_rx_frame_softmac'
drivers/staging/rtl8187se/built-in.o:(.text+0x1a12b): first defined here
ld: Warning: size of symbol `ieee80211_rx_frame_softmac' changed from
1197 in drivers/staging/rtl8187se/built-in.o to 2099 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `init_mgmt_queue':
(.text+0x1e0b0): multiple definition of `init_mgmt_queue'
drivers/staging/rtl8187se/built-in.o:(.text+0x16cae): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_start_ibss_wq':
(.text+0x246b0): multiple definition of `ieee80211_start_ibss_wq'
drivers/staging/rtl8187se/built-in.o:(.text+0x1a952): first defined here
ld: Warning: size of symbol `ieee80211_start_ibss_wq' changed from 495
in drivers/staging/rtl8187se/built-in.o to 609 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `enqueue_mgmt':
(.text+0x1dfe0): multiple definition of `enqueue_mgmt'
drivers/staging/rtl8187se/built-in.o:(.text+0x16c10): first defined here
ld: Warning: size of symbol `enqueue_mgmt' changed from 73 in
drivers/staging/rtl8187se/built-in.o to 88 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_send_probe':
(.text+0x22bf0): multiple definition of `ieee80211_send_probe'
drivers/staging/rtl8187se/built-in.o:(.text+0x182d4): first defined here
ld: Warning: size of symbol `ieee80211_send_probe' changed from 65 in
drivers/staging/rtl8187se/built-in.o to 749 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `softmac_mgmt_xmit':
(.text+0x21e80): multiple definition of `softmac_mgmt_xmit'
drivers/staging/rtl8187se/built-in.o:(.text+0x17e73): first defined here
ld: Warning: size of symbol `softmac_mgmt_xmit' changed from 334 in
drivers/staging/rtl8187se/built-in.o to 492 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_softmac_scan_wq':
(.text+0x22f40): multiple definition of `ieee80211_softmac_scan_wq'
drivers/staging/rtl8187se/built-in.o:(.text+0x1a5d8): first defined here
ld: Warning: size of symbol `ieee80211_softmac_scan_wq' changed from 320
in drivers/staging/rtl8187se/built-in.o to 440 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `eprom_r':
(.text+0x0): multiple definition of `eprom_r'
drivers/staging/rtl8187se/built-in.o:(.text+0x65dc): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_get_beacon_':
(.text+0x1f7e0): multiple definition of `ieee80211_get_beacon_'
drivers/staging/rtl8187se/built-in.o:(.text+0x179c4): first defined here
drivers/staging/rtl8192su/built-in.o: In function
`ieee80211_resp_to_auth':
(.text+0x232e0): multiple definition of `ieee80211_resp_to_auth'
drivers/staging/rtl8187se/built-in.o:(.text+0x18822): first defined here
ld: Warning: size of symbol `ieee80211_resp_to_auth' changed from 70 in
drivers/staging/rtl8187se/built-in.o to 511 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `eprom_w':
(.text+0x40): multiple definition of `eprom_w'
drivers/staging/rtl8187se/built-in.o:(.text+0x661c): first defined here
ld: Warning: size of symbol `eprom_w' changed from 115 in
drivers/staging/rtl8187se/built-in.o to 134 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/rtl8192su/built-in.o: In function `read_nic_word':
(.text+0x12dc0): multiple definition of `read_nic_word'
drivers/staging/rtl8187se/built-in.o:(.text+0x54): first defined here
ld: Warning: size of symbol `read_nic_word' changed from 43 in
drivers/staging/rtl8187se/built-in.o to 118 in
drivers/staging/rtl8192su/built-in.o
drivers/staging/vt6655/built-in.o: In function `rotr1':
(.text+0x1c0a4): multiple definition of `rotr1'
drivers/staging/rt2860/built-in.o:(.text+0x1ac65): first defined here
drivers/staging/vt6655/built-in.o: In function `MlmeThread':
(.text+0x3235): multiple definition of `MlmeThread'
drivers/staging/rt2870/built-in.o:(.text+0x42107): first defined here
ld: Warning: size of symbol `MlmeThread' changed from 143 in
drivers/staging/rt2870/built-in.o to 150 in
drivers/staging/vt6655/built-in.o
drivers/staging/vt6655/built-in.o: In function `tkip_sbox':
(.text+0x1c050): multiple definition of `tkip_sbox'
drivers/staging/rt2860/built-in.o:(.text+0x1ac16): first defined here
ld: Warning: size of symbol `tkip_sbox' changed from 79 in
drivers/staging/rt2860/built-in.o to 84 in
drivers/staging/vt6655/built-in.o
drivers/staging/vt6655/built-in.o: In function `xor_32':
(.text+0x20cc5): multiple definition of `xor_32'
drivers/staging/rt2860/built-in.o:(.text+0x1b5e1): first defined here
ld: Warning: size of symbol `xor_32' changed from 61 in
drivers/staging/rt2860/built-in.o to 46 in
drivers/staging/vt6655/built-in.o
drivers/staging/vt6655/built-in.o: In function `xor_128':
(.text+0x20c7c): multiple definition of `xor_128'
drivers/staging/rt2860/built-in.o:(.text+0x1b4f5): first defined here
ld: Warning: size of symbol `xor_128' changed from 61 in
drivers/staging/rt2860/built-in.o to 73 in
drivers/staging/vt6655/built-in.o
make[2]: *** [drivers/staging/built-in.o] Error 1
make[1]: *** [drivers/staging] Error 2
make: *** [drivers] Error 2

Please find the config below.

Regards--
Subrata

===========
.config
===========
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31-rc5
# Mon Aug 10 16:39:58 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
# CONFIG_HOTPLUG is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_SLOW_WORK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_ELAN=y
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
CONFIG_X86_SUMMIT=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_VMI=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_MEMTEST=y
CONFIG_X86_CYCLONE_TIMER=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_OLD_MCE=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_X86_CPU_DEBUG=m
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
# CONFIG_X86_PAE is not set
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set

#
# NUMA (Summit) requires SMP, 64GB highmem support, ACPI
#
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_CMDLINE_OVERRIDE=y

#
# Power management and ACPI options
#
# CONFIG_PM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_ELAN_CPUFREQ=y
CONFIG_SC520_CPUFREQ=m
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_GX_SUSPMOD=m
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=m
# CONFIG_X86_LONGRUN is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
# CONFIG_MCA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
# CONFIG_UNIX is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_NET_DSA_TAG_TRAILER is not set
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=m
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=m
CONFIG_MAC80211_DEFAULT_PS=y
CONFIG_MAC80211_DEFAULT_PS_VALUE=1

#
# Rate control algorithm selection
#
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_NET_9P=m
CONFIG_NET_9P_DEBUG=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPACPI is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_DELL_LAPTOP=m
CONFIG_ISL29003=m
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
CONFIG_IEEE1394_PCILYNX=y

#
# SBP-2 support (for storage devices) requires SCSI
#
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
CONFIG_IEEE1394_RAWIO=y
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=y
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=y
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=m
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_LANCE=m
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_DNET=m
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=y
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_AT1700 is not set
CONFIG_DEPCA=y
CONFIG_HP100=y
CONFIG_NET_ISA=y
CONFIG_E2100=y
CONFIG_EWRK3=y
# CONFIG_EEXPRESS is not set
CONFIG_EEXPRESS_PRO=m
CONFIG_HPLAN_PLUS=y
CONFIG_HPLAN=y
CONFIG_LP486E=m
CONFIG_ETH16I=y
CONFIG_NE2000=y
CONFIG_ZNET=y
CONFIG_SEEQ8005=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_AC3200=m
# CONFIG_APRICOT is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
CONFIG_FORCEDETH_NAPI=y
CONFIG_CS89x0=m
CONFIG_E100=m
CONFIG_LNE390=y
CONFIG_FEALNX=m
CONFIG_NATSEMI=y
CONFIG_NE2K_PCI=m
CONFIG_NE3210=m
CONFIG_ES3210=m
CONFIG_8139CP=m
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=y
CONFIG_EPIC100=y
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=m
CONFIG_KS8842=m
# CONFIG_VIA_RHINE is not set
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
# CONFIG_ATP is not set
# CONFIG_DE600 is not set
# CONFIG_DE620 is not set
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=y
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IP1000=y
CONFIG_IGB=m
CONFIG_IGBVF=m
CONFIG_NS83820=m
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
CONFIG_SIS190=m
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=y
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=y
# CONFIG_IBMTR is not set
CONFIG_IBMOL=y
# CONFIG_IBMLS is not set
CONFIG_3C359=y
CONFIG_TMS380TR=y
CONFIG_TMSPCI=y
CONFIG_SKISA=m
CONFIG_PROTEON=m
# CONFIG_ABYSS is not set
CONFIG_SMCTR=m

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
# CONFIG_ARLAN is not set
CONFIG_WAVELAN=m
CONFIG_WLAN_80211=y
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_THINFIRM=m
CONFIG_LIBERTAS_THINFIRM_USB=m
# CONFIG_AIRO is not set
CONFIG_ATMEL=y
# CONFIG_PCI_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_MWL8K is not set
# CONFIG_P54_COMMON is not set
CONFIG_ATH_COMMON=m
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y
CONFIG_ATH9K=m
# CONFIG_ATH9K_DEBUG is not set
CONFIG_AR9170_USB=m
CONFIG_AR9170_LEDS=y
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
# CONFIG_IPW2200_QOS is not set
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=m
CONFIG_LIBIPW_DEBUG=y
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLAGN is not set
CONFIG_IWL3945=m
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
# CONFIG_HOSTAP is not set
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PIO=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
CONFIG_B43_FORCE_PIO=y
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_ZD1211RW=m
CONFIG_ZD1211RW_DEBUG=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2500USB=m
# CONFIG_RT73USB is not set
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_RFKILL=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_HERMES is not set
CONFIG_IWM=m

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_SMSC95XX=y
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=y
CONFIG_LAPBETHER=m
# CONFIG_X25_ASY is not set
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
# CONFIG_ATM_DRIVERS is not set
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
CONFIG_PLIP=m
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
CONFIG_PPPOATM=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=y
CONFIG_MISDN=y
# CONFIG_MISDN_DSP is not set
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
# CONFIG_MISDN_HFCMULTI is not set
# CONFIG_MISDN_HFCUSB is not set
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
# CONFIG_HISAX_NO_SENDCOMPLETE is not set
# CONFIG_HISAX_NO_LLC is not set
# CONFIG_HISAX_NO_KEYPAD is not set
# CONFIG_HISAX_1TR6 is not set
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_0=y
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_AVM_A1=y
# CONFIG_HISAX_FRITZPCI is not set
# CONFIG_HISAX_AVM_A1_PCMCIA is not set
CONFIG_HISAX_ELSA=y
# CONFIG_HISAX_IX1MICROR2 is not set
# CONFIG_HISAX_DIEHLDIVA is not set
# CONFIG_HISAX_ASUSCOM is not set
CONFIG_HISAX_TELEINT=y
CONFIG_HISAX_HFCS=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_SPORTSTER=y
# CONFIG_HISAX_MIC is not set
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_ISURF=y
CONFIG_HISAX_HSTSAPHIR=y
CONFIG_HISAX_BKM_A4T=y
# CONFIG_HISAX_SCT_QUADRO is not set
# CONFIG_HISAX_GAZEL is not set
# CONFIG_HISAX_HFC_PCI is not set
CONFIG_HISAX_W6692=y
# CONFIG_HISAX_HFC_SX is not set
CONFIG_HISAX_ENTERNOW_PCI=y
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
# CONFIG_HISAX_FRITZ_PCIPNP is not set
CONFIG_HISAX_HDLC=y

#
# Active cards
#
CONFIG_ISDN_DRV_ICN=y
CONFIG_ISDN_DRV_PCBIT=y
# CONFIG_ISDN_DRV_SC is not set
CONFIG_ISDN_DRV_ACT2000=m
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1ISA=m
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
# CONFIG_ISDN_DRV_AVMB1_T1ISA is not set
# CONFIG_ISDN_DRV_AVMB1_B1PCMCIA is not set
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_PHONE=m
# CONFIG_PHONE_IXJ is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ATKBD is not set
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_INPORT=m
CONFIG_MOUSE_ATIXL=y
CONFIG_MOUSE_LOGIBM=y
CONFIG_MOUSE_PC110PAD=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=m
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=m
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_DIGIEPCA=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=m
CONFIG_SYNCLINK=m
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=m
CONFIG_RISCOM8=m
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
CONFIG_RIO=m
CONFIG_RIO_OLDPCI=y
CONFIG_STALDRV=y
# CONFIG_STALLION is not set
CONFIG_ISTALLION=m
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_JSM=y
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_NVRAM=y
CONFIG_DTLK=m
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_CS5535_GPIO is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
CONFIG_I2C_OCORES=y
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_I2C is not set
CONFIG_SCx200_ACB=y

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_TWL4030=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m

#
# SPI GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_CHARGER_PCF50633=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_TWL4030_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=m
CONFIG_RDC321X_WDT=m
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=m
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
CONFIG_MIXCOMWD=m
CONFIG_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_HTC_PASIC3=m
CONFIG_TPS65010=m
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_AB3100_CORE=m
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_BQ24022 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_PCF50633 is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_CADET=m
CONFIG_RADIO_RTRACK=m
CONFIG_RADIO_RTRACK2=m
# CONFIG_RADIO_AZTECH is not set
# CONFIG_RADIO_GEMTEK is not set
CONFIG_RADIO_GEMTEK_PCI=m
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
CONFIG_RADIO_SF16FMI=m
# CONFIG_RADIO_SF16FMR2 is not set
# CONFIG_RADIO_TERRATEC is not set
# CONFIG_RADIO_TRUST is not set
CONFIG_RADIO_TYPHOON=m
# CONFIG_RADIO_ZOLTRIX is not set
# CONFIG_USB_DSBR is not set
# CONFIG_USB_SI470X is not set
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
# CONFIG_FB_MB862XX_PCI_GDC is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_MBP_NVIDIA=y
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_MDA_CONSOLE=m
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_OPL4_LIB_SEQ=m
CONFIG_SND_SBAWE_SEQ=m
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL4_LIB=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_WSS_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
CONFIG_SND_AD1848=m
CONFIG_SND_ALS100=m
CONFIG_SND_AZT2320=m
CONFIG_SND_CMI8330=m
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
CONFIG_SND_ES1688=m
# CONFIG_SND_ES18XX is not set
CONFIG_SND_SC6000=m
CONFIG_SND_GUSCLASSIC=m
CONFIG_SND_GUSEXTREME=m
CONFIG_SND_GUSMAX=m
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
CONFIG_SND_OPL3SA2=m
# CONFIG_SND_OPTI92X_AD1848 is not set
CONFIG_SND_OPTI92X_CS4231=m
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
CONFIG_SND_SB8=m
CONFIG_SND_SB16=m
CONFIG_SND_SBAWE=m
CONFIG_SND_SB16_CSP=y
CONFIG_SND_SGALAXY=m
CONFIG_SND_SSCAPE=m
CONFIG_SND_WAVEFRONT=m
# CONFIG_SND_MSND_PINNACLE is not set
CONFIG_SND_MSND_CLASSIC=m
# CONFIG_SND_PCI is not set
# CONFIG_SND_USB is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_TWL4030=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM9081=m
# CONFIG_SOUND_PRIME is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_WHCI_HCD=m
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_GADGET_MUSB_HDRC is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y

#
# USB port drivers
#
CONFIG_USB_USS720=m
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_VST=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=m
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_PXA25X is not set
# CONFIG_USB_GADGET_PXA27X is not set
# CONFIG_USB_GADGET_S3C_HSOTG is not set
# CONFIG_USB_GADGET_IMX is not set
# CONFIG_USB_GADGET_S3C2410 is not set
CONFIG_USB_GADGET_M66592=y
CONFIG_USB_M66592=m
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_FSL_QE is not set
# CONFIG_USB_GADGET_CI13XXX is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LANGWELL is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_AUDIO=m
# CONFIG_USB_ETH is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FILE_STORAGE is not set
CONFIG_USB_G_SERIAL=m
CONFIG_USB_MIDI_GADGET=m
CONFIG_USB_G_PRINTER=m
# CONFIG_USB_CDC_COMPOSITE is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_TWL4030_USB=m
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
# CONFIG_UWB_HWA is not set
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=m
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_BD2802=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DEBUG_VERBOSE=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
CONFIG_ET131X=m
# CONFIG_ET131X_DEBUG is not set
CONFIG_SLICOSS=y
# CONFIG_ME4000 is not set
CONFIG_MEILHAUS=m
# CONFIG_ME0600 is not set
CONFIG_ME0900=m
CONFIG_ME1000=m
# CONFIG_ME1400 is not set
# CONFIG_ME1600 is not set
# CONFIG_ME4600 is not set
# CONFIG_ME6000 is not set
CONFIG_ME8100=m
# CONFIG_ME8200 is not set
# CONFIG_MEDUMMY is not set
CONFIG_VIDEO_GO7007=m
# CONFIG_VIDEO_GO7007_USB is not set
CONFIG_USB_IP_COMMON=y
CONFIG_USB_IP_VHCI_HCD=y
CONFIG_USB_IP_HOST=m
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
CONFIG_ECHO=m
CONFIG_USB_ATMEL=m
CONFIG_AGNX=m
CONFIG_OTUS=m
CONFIG_RT2860=y
CONFIG_RT2870=y
CONFIG_RT3070=m
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_PCI_DRIVERS=m
CONFIG_COMEDI_USB_DRIVERS=m
CONFIG_ASUS_OLED=y
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_ALTERA_PCIE_CHDMA is not set
CONFIG_RTL8187SE=y
CONFIG_RTL8192SU=y
CONFIG_INPUT_MIMIO=m
# CONFIG_TRANZPORT is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_RAM_CONSOLE is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_POHMELFS is not set
CONFIG_B3DFG=y
CONFIG_PLAN9AUTH=y
CONFIG_HECI=y
# CONFIG_LINE6_USB is not set
CONFIG_VT6655=y
# CONFIG_FB_UDL is not set
CONFIG_X86_PLATFORM_DEVICES=y

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_MARKERS is not set
CONFIG_SAMPLE_TRACEPOINTS=m
CONFIG_SAMPLE_KOBJECT=m
CONFIG_SAMPLE_KPROBES=m
# CONFIG_SAMPLE_KRETPROBES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_4KSTACKS is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=m
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
===========

