Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYEZIZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYEZIZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYEZIZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:25:27 -0400
Received: from ip-213-177-134-166.dsl-static.scarlet.be ([213.177.134.166]:26549
	"EHLO telenet.ba.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751363AbYEZIZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:25:26 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2008 04:25:25 EDT
From: Maarten Vanraes <maarten@ba.be>
To: linux-kernel@vger.kernel.org
Subject: megaraid_sata vs megasr
Date: Mon, 26 May 2008 10:05:30 +0200
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805261005.31015.maarten@ba.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, (can you CC me? i'm not on the list)

I have a LSI MegaRAID SAS 8204ELP card, and since it wasn't recognized by any 
driver, i tried using the megasr driver supplied by LSI (it also supplies 
open_source code with it), i had to modify the code a bit to get it to boot 
with kernel-2.6.21 . but there's a very high iowait on it. i'm wondering if 
the megaraid_sas driver is meant to be the driver for the same hardware as 
megasr? would it help if i just added another PCI ID to the module and try 
that one?

Sincerely,

Maarten Vanraes

[] # lspci -s 08:00.0 -vvvn
08:00.0 0100: 1000:0059 (rev 08)
        Subsystem: 1000:3002
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR+ <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 3000 [size=256]
        Region 1: Memory at d8410000 (64-bit, non-prefetchable) [size=16K]
        Region 3: Memory at d8400000 (64-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at d8000000 [disabled] [size=2M]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s <64ns, 
L1 <1us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency 
L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [98] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=1
                Vector table: BAR=1 offset=00002000
                PBA: BAR=1 offset=00003000
        Capabilities: [100] Advanced Error Reporting <?>
        Kernel driver in use: megasr


-- 
Maarten Vanraes
BA NV: IT & Security
