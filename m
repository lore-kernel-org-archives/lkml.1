Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYGGUyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYGGUyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbYGGUxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:53:53 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:42790 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbYGGUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:53:52 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: rt2400-devel@lists.sourceforge.net
Subject: rt2500pci: Failed to initialize hw. But works with ancient rt2500-1.1.0
Date: Mon, 7 Jul 2008 22:53:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072253.46295.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: ddb05343e7e50baad047250fd48c5445
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I'm not able to load rt2500pci from 2.6.26-rc9 under Gentoo.
This card currently works under Debian Etch with 2.6.18 kernel and 
rt2500-source 1.1.0+cvs20060620-3.

lspci -vvvv
Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
Subsystem: RaLink Unknown device 2560
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- 
SERR+ FastB2B-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 185
Region 0: Memory at fba00000 (32-bit, non-prefetchable) [size=8K]
Capabilities: [40] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-

dmesg 2.6.18
PCI: Enabling device 0000:00:0c.0 (0110 -> 0112)
ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 185
rt2500 1.1.0 CVS 2005/07/10 http://rt2x00.serialmonkey.com

dmesg 2.6.26-rc9
ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
phy0: Selected rate control algorithm 'pid'
phy0: Failed to initialize wep
phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
rt2500pci: probe of 0000:00:0c.0 failed with error -12

.config 2.6.18
precompiled Kernel from Debian

.config 2.6.26-rc9
<http://www-user.tu-chemnitz.de/~stefb/rt2500pci/config>

Next I'm going to test 2.6.24 and 2.6.25 to check whether it's an regression 
or not.


Regards,
Stefan
