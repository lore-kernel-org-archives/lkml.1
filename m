Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbXI2Tsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbXI2Tsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 15:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbXI2TsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 15:48:22 -0400
Received: from mail.tmr.com ([64.65.253.246]:41850 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbXI2TsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 15:48:20 -0400
Message-ID: <46FEAC02.5030801@tmr.com>
Date: Sat, 29 Sep 2007 15:48:18 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: [FYI] 2.6.23-rc8-git3 misc observations
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Running FC6 (updated this am) the temp sensors GNOME applet works with 
the kernel.org kernel, not the FC6 kernel. This has been true for a 
while, and I've stopped chasing it, I don't really care right now, since 
the sensors command works fine and that's what my daemon checks.

Using 2.6.23-rc8 (no git) the NIC came up at 100Mbit instead of gigE 
once, not reproducible. Just in case this kicks off a bunch of "mee too" 
replies. lspci info follows text.

Boot times: I occasionally boot repeatedly for various tests, these are 
the fastest of three (or more) boots of a given kernel, ID is what uname 
gives.

2.6.21-sd046                    55.29
2.6.21-cfs-v6                   55.93
2.6.20-1.2944.fc6               64.71
2.6.23-rc8-git3                 65.06
2.6.22.7-57.fc6                 69.02


lspci:

02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet 
Controller
        Subsystem: ASUSTeK Computer Inc. Unknown device 81c2
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PER
R-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 223
        Region 0: Memory at cffe0000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at d800 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: 64bit+ 
Queue=0/0 Enable+
                Address: 00000000fee0200c  Data: 41d1
        Capabilities: [e0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, 
ExtTag-
                Device: Latency L0s <512ns, L1 <64us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM unknown, 
Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Device Serial Number De-LE-TE-D

-- 
Bill Davidsen
  He was a full-time professional cat, not some moonlighting
ferret or weasel. He knew about these things.

