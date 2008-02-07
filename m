Return-Path: <linux-kernel-owner+w=401wt.eu-S1763043AbYBGWdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763043AbYBGWdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbYBGWdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:33:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:54492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbYBGWdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:33:44 -0500
From: Martin Rogge <marogge@onlinehome.de>
To: linux-kernel@vger.kernel.org
Subject: Re: e1000 1sec latency problem
Date: Thu, 7 Feb 2008 23:31:32 +0100
User-Agent: KMail/1.9.7
Cc: Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802072331.33099.marogge@onlinehome.de>
X-Provags-ID: V01U2FsdGVkX19kvgGggBvAe19cbmNnMByRANAS8dwh/WSTDP8
 4Jkr2dviDEE4J8kc05wJTlGaacD3fQjj1OzwhnIm4UTCtk1ODL
 yJ8DIi+qDkpVqa0AIPDpydetChT2rXW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> Hi!
> 
> I have the famous e1000 latency problems:

Hi, I have the same problem with my Thinkpad T60. 

root@zorro:~# ping arnold
PING arnold (192.168.158.6) 56(84) bytes of data.
64 bytes from arnold (192.168.158.6): icmp_seq=1 ttl=64 time=49.7 ms
64 bytes from arnold (192.168.158.6): icmp_seq=2 ttl=64 time=0.438 ms
64 bytes from arnold (192.168.158.6): icmp_seq=3 ttl=64 time=1000 ms
64 bytes from arnold (192.168.158.6): icmp_seq=4 ttl=64 time=0.970 ms
64 bytes from arnold (192.168.158.6): icmp_seq=5 ttl=64 time=885 ms
64 bytes from arnold (192.168.158.6): icmp_seq=6 ttl=64 time=0.484 ms
64 bytes from arnold (192.168.158.6): icmp_seq=7 ttl=64 time=529 ms
64 bytes from arnold (192.168.158.6): icmp_seq=8 ttl=64 time=1.02 ms
64 bytes from arnold (192.168.158.6): icmp_seq=9 ttl=64 time=149 ms
64 bytes from arnold (192.168.158.6): icmp_seq=10 ttl=64 time=0.549 ms
64 bytes from arnold (192.168.158.6): icmp_seq=11 ttl=64 time=0.829 ms

--- arnold ping statistics ---
11 packets transmitted, 11 received, 0% packet loss, time 9999ms
rtt min/avg/max/mdev = 0.438/238.113/1000.967/365.279 ms, pipe 2
root@zorro:~# uname -a
Linux zorro 2.6.24 #6 SMP PREEMPT Sun Feb 3 18:27:48 CET 2008 i686 Intel(R) 
Core(TM)2 CPU         T7200  @ 2.00GHz GenuineIntel GNU/Linux
root@zorro:~# lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 
945GT Express Memory Controller Hub (rev 03)
        Subsystem: Lenovo Unknown device 2015
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

[stuff deleted]

02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet 
Controller
        Subsystem: Lenovo ThinkPad T60
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at ee000000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at 3000 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <512ns, L1 <64us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Device Serial Number 71-3a-c3-ff-ff-58-15-00


Unfortunately the e1000e driver is not an option as it will not detect the 
NIC:

----from dmesg with e1000 compiled in:
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 
00:15:58:c3:3a:71
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection

----from dmesg with e1000e compiled in:
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.

Any pointers?

Thanks,

Martin


