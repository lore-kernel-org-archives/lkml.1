Return-Path: <linux-kernel-owner+w=401wt.eu-S934336AbZLFWMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336AbZLFWMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 17:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934318AbZLFWMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 17:12:05 -0500
Received: from netrider.rowland.org ([192.131.102.5]:35256 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934311AbZLFWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 17:12:03 -0500
Date: Sun, 6 Dec 2009 17:12:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ivo van Doorn <IvDoorn@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>
cc: linux-wireless@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: REGRESSION for RT2561/RT61 in 2.6.32
Message-ID: <Pine.LNX.4.44L0.0912061705050.9883-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late notice; I haven't tried running new kernels on this 
computer in a long time.

When I use 2.6.32 (or indeed 2.6.32-rc1), it works fine up until the 
point where the wireless card is ifconfig'ed.  Then not long afterward 
(a few seconds to a minute) the system hangs.

# lspci -vv -s d.0
00:0d.0 Network controller: RaLink RT2561/RT61 802.11g PCI
        Subsystem: Linksys WMP54G ver 4.1
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at cfff0000 (32-bit, non-prefetchable) [size=32K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: rt61pci
        Kernel modules: rt61pci

While the system is hung, Alt-SysRq-keys still work but nothing else
shows up when I type (using a VT console, not X).  However I don't know
what debugging to do or what to look for.

Under 2.6.31 everything works okay.

Any help appreciated,

Alan Stern

