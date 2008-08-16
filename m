Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYHPFP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYHPFP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 01:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYHPFPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 01:15:50 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:34559 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbYHPFPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 01:15:49 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/3] ATA Kconfig cleanup
Date: Sat, 16 Aug 2008 15:15:35 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <fioca491u666bcq55b745o8aodljn9qp9m@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Three patches to cleanup the ATA menu:
 - hide ATA SFF behind new SATA and PATA enables
 - sort drivers into one list
 - a few text changes and break a couple long help lines.

Result below (some items not there due to non-x86 dependencies).  
Compile tested on x86.

Grant.

 .config - Linux Kernel v2.6.27-rc3 Configuration
 ------------------------------------------------------------------------------
  +------------ Serial ATA and Parallel ATA (SATA/PATA) drivers ------------+
  ¦  Arrow keys navigate the menu.  <Enter> selects submenus --->.          ¦
  ¦  Highlighted letters are hotkeys.  Pressing <Y> includes, <N> excludes, ¦
  ¦  <M> modularizes features.  Press <Esc><Esc> to exit, <?> for Help, </> ¦
  ¦  for Search.  Legend: [*] built-in  [ ] excluded  <M> module  < >       ¦
  ¦ +---------------------------------------------------------------------+ ¦
  ¦ ¦    --- Serial ATA and Parallel ATA (SATA/PATA) drivers              ¦ ¦
  ¦ ¦    [*]   ATA ACPI Support                                           ¦ ¦
  ¦ ¦    [ ]   SATA Port Multiplier support                               ¦ ¦
  ¦ ¦    <*>   AHCI SATA support                                          ¦ ¦
  ¦ ¦    < >   Silicon Image 3124/3132 SATA support                       ¦ ¦
  ¦ ¦    [*]   SATA Serial ATA support (NEW)                              ¦ ¦
  ¦ ¦    [*]   PATA Parallel ATA support (NEW)                            ¦ ¦
  ¦ ¦    < >     ACPI firmware driver for PATA                            ¦ ¦
  ¦ ¦    < >     ALi PATA support (Experimental)                          ¦ ¦
  ¦ ¦    < >     AMD/NVidia PATA support                                  ¦ ¦
  ¦ ¦    < >     ARTOP 6210/6260 PATA support                             ¦ ¦
  ¦ ¦    < >     ATI PATA support                                         ¦ ¦
  ¦ ¦    < >     CMD640 PCI PATA support (Very Experimental)              ¦ ¦
  ¦ ¦    < >     CMD64x PATA support                                      ¦ ¦
  ¦ ¦    < >     CMD / Silicon Image 680 PATA support                     ¦ ¦
  ¦ ¦    < >     Compaq Triflex PATA support                              ¦ ¦
  ¦ ¦    < >     CS5510/5520 PATA support                                 ¦ ¦
  ¦ ¦    < >     CS5530 PATA support (Experimental)                       ¦ ¦
  ¦ ¦    < >     CS5535 PATA support (Experimental) (NEW)                 ¦ ¦
  ¦ ¦    < >     CS5536 PATA support (Experimental) (NEW)                 ¦ ¦
  ¦ ¦    < >     Cypress CY82C693 PATA support (Very Experimental)        ¦ ¦
  ¦ ¦    < >     EFAR SLC90E66 support                                    ¦ ¦
  ¦ ¦    < >     Generic ATA support                                      ¦ ¦
  ¦ ¦    < >     HPT 343/363 PATA support                                 ¦ ¦
  ¦ ¦    < >     HPT 366/368 PATA support                                 ¦ ¦
  ¦ ¦    < >     HPT 370/370A/371/372/374/302 PATA support (Experimental) ¦ ¦
  ¦ ¦    < >     HPT 372N/302N PATA support (Very Experimental)           ¦ ¦
  ¦ ¦    < >     Initio 162x SATA support                                 ¦ ¦
  ¦ ¦    < >     Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support           ¦ ¦
  ¦ ¦    < >     Intel PATA MPIIX support                                 ¦ ¦
  ¦ ¦    < >     Intel PATA old PIIX support                              ¦ ¦
  ¦ ¦    < >     Intel SCH PATA support                                   ¦ ¦
  ¦ ¦    < >     IT8211/2 PATA support                                    ¦ ¦
  ¦ ¦    < >     IT8213 PATA support (Experimental)                       ¦ ¦
  ¦ ¦    <*>     JMicron PATA support                                     ¦ ¦
  ¦ ¦    < >     Marvell PATA support via legacy mode                     ¦ ¦
  ¦ ¦    < >     Marvell SATA support (HIGHLY EXPERIMENTAL)               ¦ ¦
  ¦ ¦    < >     Nat Semi NS87410 PATA support (Experimental)             ¦ ¦
  ¦ ¦    < >     Nat Semi NS87415 PATA support (Experimental)             ¦ ¦
  ¦ ¦    < >     NETCELL Revolution RAID support                          ¦ ¦
  ¦ ¦    < >     Ninja32/Delkin Cardbus ATA support (Experimental)        ¦ ¦
  ¦ ¦    < >     NVIDIA SATA support                                      ¦ ¦
  ¦ ¦    < >     OPTI621/6215 PATA support (Very Experimental)            ¦ ¦
  ¦ ¦    < >     OPTI FireStar PATA support (Very Experimental)           ¦ ¦
  ¦ ¦    < >     Pacific Digital ADMA support                             ¦ ¦
  ¦ ¦    < >     Pacific Digital SATA QStor support                       ¦ ¦
  ¦ ¦    < >     PC Tech RZ1000 PATA support                              ¦ ¦
  ¦ ¦    < >     Promise PATA 2027x support                               ¦ ¦
  ¦ ¦    < >     Promise older PATA controller support (Experimental)     ¦ ¦
  ¦ ¦    < >     Promise SATA SX4 support                                 ¦ ¦
  ¦ ¦    < >     Promise SATA TX2/TX4 support                             ¦ ¦
  ¦ ¦    < >     RADISYS 82600 PATA support (Very Experimental)           ¦ ¦
  ¦ ¦    < >     SC1200 PATA support (Very Experimental)                  ¦ ¦
  ¦ ¦    < >     ServerWorks Frodo / Apple K2 SATA support                ¦ ¦
  ¦ ¦    < >     ServerWorks OSB4/CSB5/CSB6/HT1000 PATA support           ¦ ¦
  ¦ ¦    < >     Silicon Image SATA support                               ¦ ¦
  ¦ ¦    < >     SiS 964/965/966/180 SATA support                         ¦ ¦
  ¦ ¦    < >     SiS PATA support (Experimental)                          ¦ ¦
  ¦ ¦    < >     ULi Electronics SATA support                             ¦ ¦
  ¦ ¦    < >     VIA PATA support                                         ¦ ¦
  ¦ ¦    < >     VIA SATA support                                         ¦ ¦
  ¦ ¦    < >     VITESSE VSC-7174 / INTEL 31244 SATA support              ¦ ¦
  ¦ ¦    < >     Winbond SL82C105 PATA support                            ¦ ¦
  ¦ +---------------------------------------------------------------------+ ¦
  +-------------------------------------------------------------------------¦
  ¦                    <Select>    < Exit >    < Help >                     ¦
  +-------------------------------------------------------------------------+

