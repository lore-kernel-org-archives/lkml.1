Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYGPUmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYGPUmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYGPUmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:42:33 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:50420 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYGPUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:42:32 -0400
Date: Wed, 16 Jul 2008 16:41:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: unused Kconfig vars under drivers/
Message-ID: <alpine.LFD.1.10.0807161639510.13507@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  while i'll do a more formal listing of these toward the end of the
merge window, here's a quick listing of defined Kconfig variables
under drivers/ that are currently unreferenced, if anyone wants to
deal with them ahead of time.  (i know that some fixes are already in
the queue.)


>>>>> APOLLO_ELPLUS
drivers/net/Kconfig:336:config APOLLO_ELPLUS
>>>>> B43LEGACY_DMA_MODE
drivers/net/wireless/b43legacy/Kconfig:87:config B43LEGACY_DMA_MODE
>>>>> B43LEGACY_PCICORE_AUTOSELECT
drivers/net/wireless/b43legacy/Kconfig:32:config B43LEGACY_PCICORE_AUTOSELECT
>>>>> B43LEGACY_PIO_MODE
drivers/net/wireless/b43legacy/Kconfig:94:config B43LEGACY_PIO_MODE
>>>>> B43_PCICORE_AUTOSELECT
drivers/net/wireless/b43/Kconfig:39:config B43_PCICORE_AUTOSELECT
>>>>> BLK_DEV_HD_ONLY
drivers/ide/Kconfig:1035:config BLK_DEV_HD_ONLY
drivers/ide/Kconfig:1059:	def_bool BLK_DEV_HD_ONLY
>>>>> CAN_DEBUG_DEVICES
drivers/net/can/Kconfig:15:config CAN_DEBUG_DEVICES
>>>>> DE_AOC
drivers/isdn/hisax/l3dss1.c:355:#ifdef HISAX_DE_AOC
drivers/isdn/hisax/l3dss1.c:424:#else  /* not HISAX_DE_AOC */
drivers/isdn/hisax/l3dss1.c:426:#endif /* not HISAX_DE_AOC */
drivers/isdn/hisax/Kconfig:32:config DE_AOC
>>>>> FB_N411
drivers/video/Kconfig:708:config FB_N411
>>>>> IPDDP_DECAP
drivers/net/appletalk/ipddp.h:24:#define IPDDP_DECAP	2
drivers/net/appletalk/Kconfig:114:config IPDDP_DECAP
drivers/net/appletalk/ipddp.c:46:static int ipddp_mode = IPDDP_DECAP;
drivers/net/appletalk/ipddp.c:99:	if(ipddp_mode == IPDDP_DECAP)
drivers/net/appletalk/ipddp.c:137:	if(ipddp_mode == IPDDP_DECAP)
>>>>> IWL4965_LEDS
drivers/net/wireless/iwlwifi/Kconfig:56:config IWL4965_LEDS
>>>>> MTD_NAND_AT91_ECC_SOFT
drivers/mtd/nand/Kconfig:300:config MTD_NAND_AT91_ECC_SOFT
>>>>> SCSI_QLOGIC_FC_FIRMWARE
drivers/scsi/Kconfig:1327:config SCSI_QLOGIC_FC_FIRMWARE
>>>>> SERIAL_CPM_SCC1
drivers/serial/Kconfig:1156:config SERIAL_CPM_SCC1
>>>>> SERIAL_CPM_SCC2
drivers/serial/Kconfig:1162:config SERIAL_CPM_SCC2
>>>>> SERIAL_CPM_SCC3
drivers/serial/Kconfig:1168:config SERIAL_CPM_SCC3
>>>>> SERIAL_CPM_SCC4
drivers/serial/Kconfig:1174:config SERIAL_CPM_SCC4
>>>>> SERIAL_CPM_SMC1
drivers/serial/Kconfig:1180:config SERIAL_CPM_SMC1
>>>>> SERIAL_CPM_SMC2
drivers/serial/Kconfig:1186:config SERIAL_CPM_SMC2
>>>>> USB_OHCI_HCD_PCI
drivers/usb/host/Kconfig:186:config USB_OHCI_HCD_PCI
>>>>> VIDEO_BT848_DVB
drivers/media/video/bt8xx/Kconfig:24:config VIDEO_BT848_DVB
>>>>> VIDEO_ZORAN_AVS6EYES
drivers/media/video/Kconfig:668:config VIDEO_ZORAN_AVS6EYES
>>>>> VIDEO_ZORAN_BUZ
drivers/media/video/Kconfig:619:config VIDEO_ZORAN_BUZ
>>>>> VIDEO_ZORAN_DC10
drivers/media/video/Kconfig:628:config VIDEO_ZORAN_DC10
>>>>> VIDEO_ZORAN_LML33
drivers/media/video/Kconfig:648:config VIDEO_ZORAN_LML33
drivers/media/video/Kconfig:658:config VIDEO_ZORAN_LML33R10
>>>>> VIDEO_ZORAN_LML33R10
drivers/media/video/Kconfig:658:config VIDEO_ZORAN_LML33R10

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
