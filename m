Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZAKUYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZAKUYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbZAKUYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:24:22 -0500
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:11506 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZAKUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:24:20 -0500
From: "Jesse F. Hughes" <jesse@phiwumbda.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Various problems with new AMD 64 HP Pavilion Desktop machine. (1/2)
References: <87r63ci7nb.fsf@phiwumbda.org>
	<20090110153014.GA19704@electric-eye.fr.zoreil.com>
Organization: The Eternal (and Int'l) Order of Palsy-Walsies -- President
Content-Type: text/plain; charset=US-ASCII
Date: Sun, 11 Jan 2009 15:23:33 -0500
In-Reply-To: <20090110153014.GA19704@electric-eye.fr.zoreil.com> (Francois Romieu's message of "Sat, 10 Jan 2009 16:30:14 +0100")
Message-ID: <87mydxegmy.fsf@phiwumbda.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> writes:

> Jesse F. Hughes <jesse@phiwumbda.org> :
> [...]
>> I seem to be having a whole slew of problems with my new (refurbished)
>> computer and I'm bumfuzzled about how to solve them.  A poster on
>> comp.os.linux.hardware suggested I post a message here.
>
> Your message appears with an unusual Content-Type which make it a bit
> unpleasant to read/answer. Please check it.

Sorry about that!  I don't know why Gnus split the message when
posting it, but I imagine the fault is mine.

> [...]
>> * My r8168 driver (latest available from realtek site) acts flaky.
>
> Which version ? 8.0.10 ?

Yes, that's right.

>> The ethernet card works for a while, but then just craps out,
>> receiving and sending no packets at all.  This usually happens during
>> a sizeable download.  Removing and reloading the driver fixes the
>> problem for a short while.
>
> Can you give the in-kernel r8169 driver a try ? The 2.6.28 r8169 driver
> should build with your kernel.
>
> [...]

I've done that as well, and should have said so.  The behavior is just
the same.  I can load the module and connect to my DHCP server without
any problem, but if I try a large download, the download stalls and I
can find no evidence that any packets are being transmitted or
received.

>> Here's the output of lspci -vvv:
> [...]
>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
>> 	Subsystem: Hewlett-Packard Company Device 2a6f
>> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>> 	Latency: 0, Cache Line Size: 32 bytes
>> 	Interrupt: pin A routed to IRQ 2298
>> 	Region 0: I/O ports at e800 [size=256]
>> 	Region 2: Memory at febff000 (64-bit, non-prefetchable) [size=4K]
>> 	Region 4: Memory at f8ff0000 (64-bit, prefetchable) [size=64K]
>> 	Expansion ROM at febc0000 [disabled] [size=128K]
>> 	Capabilities: [40] Power Management version 3
>> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>> 	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
>> 		Address: 00000000fee0f00c  Data: 41a1
>> 	Capabilities: [70] Express (v1) Endpoint, MSI 01
>> 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
>> 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
>> 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
>> 			ClockPM+ Suprise- LLActRep- BwNot-
>> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>> 	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
>> 		Vector table: BAR=4 offset=00000000
>> 		PBA: BAR=4 offset=00000800
>> 	Capabilities: [d0] Vital Product Data <?>
>> 	Capabilities: [100] Advanced Error Reporting <?>
>> 	Capabilities: [140] Virtual Channel <?>
>> 	Capabilities: [160] Device Serial Number 81-68-10-ec-00-00-00-00
>> 	Kernel driver in use: r8169
>                               ^^^^^
>> 	Kernel modules: r8169, r8168
>
> You told you were using Realtek's r8168 module. Did you explicitely force
> modprobe to blacklist the module that you did not mean to use ?

Agh.  I'm sorry again for the confusing information.  On this boot, I
had reverted to an earlier kernel, which evidently loaded the r8169
module.  (I had moved the module away rather than blacklisted it, just
because that's what the instructions said to do.)

>> * My Hauppauge 1800 (?) tv card seems to be acting up.  Sometimes when
>> I lspci -vvv, I see
>> 
>>   !!! Unknown header type 7f
>
> Add a -x option and you will probably see that the PCI configuration
> space contains nothing but "ff" (it's not good).

I can't seem to reproduce the unknown header type message today, and
the -x does *not* produce the "ff"s you mention, but I sure do see
some suspicious ffs in the output of dmesg:

[ 6455.276014] cx23885[0]: VID A - dma channel status dump
[ 6455.276022] cx23885[0]:   cmds: init risc lo   : 0xffffffff
[ 6455.276026] cx23885[0]:   cmds: init risc hi   : 0xffffffff
[ 6455.276030] cx23885[0]:   cmds: cdt base       : 0xffffffff
[ 6455.276036] cx23885[0]:   cmds: cdt size       : 0xffffffff
[ 6455.276040] cx23885[0]:   cmds: iq base        : 0xffffffff
[ 6455.276045] cx23885[0]:   cmds: iq size        : 0xffffffff
[ 6455.276050] cx23885[0]:   cmds: risc pc lo     : 0xffffffff
[ 6455.276054] cx23885[0]:   cmds: risc pc hi     : 0xffffffff
[ 6455.276058] cx23885[0]:   cmds: iq wr ptr      : 0xffffffff
[ 6455.276062] cx23885[0]:   cmds: iq rd ptr      : 0xffffffff
[ 6455.276066] cx23885[0]:   cmds: cdt current    : 0xffffffff
[ 6455.276071] cx23885[0]:   cmds: pci target lo  : 0xffffffff
[ 6455.276074] cx23885[0]:   cmds: pci target hi  : 0xffffffff
[ 6455.276079] cx23885[0]:   cmds: line / byte    : 0xffffffff
[ 6455.276083] cx23885[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276100] cx23885[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276117] cx23885[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276132] cx23885[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276148] cx23885[0]:   (0x000105b0) iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276165] cx23885[0]:   (0x000105b4) iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276182] cx23885[0]:   (0x000105b8) iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276198] cx23885[0]:   (0x000105bc) iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276214] cx23885[0]:   (0x000105c0) iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276231] cx23885[0]:   (0x000105c4) iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276245] cx23885[0]:   (0x000105c8) iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276262] cx23885[0]:   (0x000105cc) iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276279] cx23885[0]:   (0x000105d0) iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276295] cx23885[0]:   (0x000105d4) iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276312] cx23885[0]:   (0x000105d8) iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276328] cx23885[0]:   (0x000105dc) iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276344] cx23885[0]:   (0x000105e0) iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276360] cx23885[0]:   (0x000105e4) iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276377] cx23885[0]:   (0x000105e8) iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276394] cx23885[0]:   (0x000105ec) iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[ 6455.276409] cx23885[0]: fifo: 0x00000040 -> 0x2840
[ 6455.276411] cx23885[0]: ctrl: 0x000105b0 -> 0x10610
[ 6455.276415] cx23885[0]:   ptr1_reg: 0xffffffff
[ 6455.276419] cx23885[0]:   ptr2_reg: 0xffffffff
[ 6455.276423] cx23885[0]:   cnt1_reg: 0xffffffff
[ 6455.276427] cx23885[0]:   cnt2_reg: 0xffffffff
[ 6455.276435] cx23885[0]/0: [ffff8800974cf400/0] timeout - dma=0x6c404000
[ 6455.276439] cx23885[0]/0: [ffff8800974ce000/1] timeout - dma=0x705e0000
[ 6455.276443] cx23885[0]/0: [ffff8800974cf000/2] timeout - dma=0x6c478000
[ 6455.276446] cx23885[0]/0: [ffff8800974ce600/3] timeout - dma=0x6c544000

Now, I can see that this is not good, but what now?

>
> Can you experience with the -H option of lspci and see what it reports
> when this happens ?

$ sudo lspci -vvv -H2
00:00.0 Class bad7: Device 0048:0020 (rev e8) (prog-if a7)
        !!! Unknown header type 40

With -H 1, I get the usual output.

> (dumb question: is this a linux-only box ?)

Yes.

> [...]
>> I'm more than a wee bit clueless about all this.  I hope that someone
>> can help me out here.  Is it a hardware issue?  Does it have something
>> to do with ACPI, as the colh poster suggested?
>
> It could be purely software r8169 and PCI problems.

That's good to hear, but what about the problems with the USB wireless
card using the rtl8187 driver?  And also the PCI wireless card that
produced error messages with the cx23885 TV card driver?  Is it
plausible that each of these issues is coincidental?  (Given my
evident cluelessness, perhaps so!)


> [...]
> I am rather confused by the fact that the dmesg and the lspci look more
> like Intel than "AMD 64" ones (see the Subject of your message).
>
> Can you clarify ?

Yes, certainly.  I guess I'm misusing terminology.  The machine has
Intel Core2 Quad CPU, not an AMD processor, but I thought that the
generic name for a 64 bit architecture was AMD 64.  At least, that's
the impression I received from http://releases.ubuntu.com/8.10/.  

Again, sorry for the confusion.  I'm pretty clueless when it comes to
hardware, architecture and so on.  

-- 
"It seems to me that in wartime Americans shouldn't be attacking each
other in this way on a *worldwide* forum.  Then again, I know I'm an
American, but I have no way of knowing that you are, which would
explain a lot."  --James Harris, on why Yanks should accept his proof
