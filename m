Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZFOD27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZFOD27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZFOD2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:28:50 -0400
Received: from slackware.com ([64.57.102.34]:41853 "EHLO bob.slackware.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZFOD2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:28:49 -0400
Date: Sun, 14 Jun 2009 20:28:46 -0700 (PDT)
From: Robby Workman <rworkman@slackware.com>
To: reinette chatre <reinette.chatre@intel.com>
cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ilw] iwlagn crash on 2.6.29.4
In-Reply-To: <1244825750.20900.468.camel@rc-desk>
Message-ID: <alpine.LNX.1.10.0906142015390.21143@bob.slackware.com>
References: <alpine.LNX.1.10.0906112246330.23960@bob.slackware.com> <1244825750.20900.468.camel@rc-desk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, reinette chatre wrote:

> On Thu, 2009-06-11 at 22:51 -0700, Robby Workman wrote:
>> On 2.6.29.4, I just got a crash in iwlagn under heavy network
>> throughput.  I was transferring a dvd iso from one box in my
>> lan to another, and the following occurred:
>>
>>    http://slackware.com/~rworkman/OOPS
>>
>> It didn't bring the entire system to a halt (thankfully);
>> removing and reloading the iwlagn module made everything
>> just fine. :-)
>>
>> If any more information is needed, let me know.  I'm more than
>> willing to test patches and such...
>
> Which hardware are you using?

3:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection
 	Subsystem: Intel Corporation Device 1211
 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 64 bytes
 	Interrupt: pin A routed to IRQ 30
 	Region 0: Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
 	Capabilities: [c8] Power Management version 3
 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [d0] MSI: Mask- 64bit+ Count=1/1 Enable+
 		Address: 00000000fee0300c  Data: 41e1
 	Capabilities: [e0] Express (v1) Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
 			MaxPayload 128 bytes, MaxReadReq 128 bytes
 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
 			ClockPM+ Surprise- LLActRep- BwNot-
 		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
 			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
 	Capabilities: [100] Advanced Error Reporting
 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
 		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
 		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
 	Capabilities: [140] Device Serial Number 78-31-d5-ff-ff-fa-22-00
 	Kernel driver in use: iwlagn
 	Kernel modules: iwlagn


> We released new ucode for 4965, 5100, 5300, and 5350 that address this
> issue. The new 4965 ucode should work fine with your driver. If you are
> using later hardware then you need a more recent driver to be able to
> use its new ucode.
>
> You can download the new ucode from:
> http://intellinuxwireless.org/?n=Downloads


Best I can tell, I'll need 2.6.30 for the new 5100 firmware, as 2.6.29.4
doesn't seem to care that the newer firmware is present:

   root@liberty:~# ls /lib/firmware/iwlwifi-5000-*
   /lib/firmware/iwlwifi-5000-1.ucode  /lib/firmware/iwlwifi-5000-2.ucode

   ... and from dmesg:
   iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.ucode
   iwlagn loaded firmware version 5.4.1.16

I guess I'll have to wait a bit, as 2.6.30 is off the table for now.
No big deal - at least it's fixed, even if not for me yet.

Thanks!

-RW

