Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXEASax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXEASax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbXEASax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:30:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:47120 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932247AbXEASav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:30:51 -0400
Cc: xyzzy@speakeasy.org, abraham.manu@gmail.com, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org, mrechberger@gmail.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 01 May 2007 20:30:48 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <20070501164054.26090@gmx.net>
Message-ID: <20070501183048.268140@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<1178031333.3958.63.camel@localhost> <20070501164054.26090@gmx.net>
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (.. was: Critical
	points about ...)
To: "Uwe Bugla" <uwe.bugla@gmx.de>, mrechberger@gmail.com,
       mchehab@infradead.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+j9RZvF3mjKT5Hj47oAV77S3DJ18isBPuLIOQJ0r
 LPUhhYChL4AqtPD6B7M3BmivDY6qn8XcbqyA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: Oe5CdYpdODB6Rm7vDGRMUTg9Ji9SWlKp
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Tue, 01 May 2007 18:40:54 +0200
Von: "Uwe Bugla" <uwe.bugla@gmx.de>
An: Mauro Carvalho Chehab <mchehab@infradead.org>, mrechberger@gmail.com
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org, abraham.manu@gmail.com, xyzzy@speakeasy.org
Betreff: Re: [linux-dvb] Re: DST/BT878 module customization (.. was: Critical	points about ...)

> 
> -------- Original-Nachricht --------
> Datum: Tue, 01 May 2007 11:55:33 -0300
> Von: Mauro Carvalho Chehab <mchehab@infradead.org>
> An: Markus Rechberger <mrechberger@gmail.com>
> CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org, Manu Abraham
> <abraham.manu@gmail.com>
> Betreff: [linux-dvb] Re: DST/BT878 module customization (.. was:
> Critical	points about ...)
> 
> > Hi Markus,
> > 
> > Em Seg, 2007-04-30 às 23:17 +0200, Markus Rechberger escreveu:
> > > Hi,
> > > 
> > > Trent Piepho wrote another patch for it, it just completes Uwe's patch
> > > in the end.
> > > 
> > >
> >
> http://linuxtv.org/hg/~tap/dst-new?cmd=changeset;node=bbdd2b53cd5c;style=gitweb
> > 
> > The above patch plus the other on
> >
> http://linuxtv.org/hg/~tap/dst-new?cmd=changeset;node=32fb55ac9501;style=gitweb
> > 
> > Implements properly the Uwe's ide. 
> > 
> > However, I did a test here applying both patches, and de-selecting dst
> > drivers.
> > 
> > With this configuration, dvb-bt8xx hangs during initialization,
> > generating an OOPS, if you have a board with DST (modprobe dvb-bt8xx
> > never returns).
> Hi, please: Could you explain to me why you are turning around the logical
> principle all the time?
> 
> Those patches (and my humble ones too of course that gained no attention
> for months) were made for the POSITIVE CASE
> in which it is ENSURED that a DST card DOES NOT EXIST in the machine, NOT
> VICE VERSA!
> 
> So please in how far isn't that fantastic work done by Trent enough?
> So it is very clear that if there are oopses and hangups if such a card
> exists and its drivers are deselected.
> No point at all!
> So please explain me the essence why you use the inversion of the given
> logic to NOT ACK or SIGN this beautiful work.
> I want to see THREE valid arguments for this turnaround illogical
> behaviour please.
> 
> Uwe
> 
> P. S.: I tested Trent's work and I can ensure that there aren't any Oopses
> at all!
> So your case studies are not only highly invented and strange, but they
> aren't any help either. I really wonder what the hell is going on in your
> brain.
> I really ask myself why you are doing this nerve war, this ping-pong game
> all the time.
> This work is done for the case where there aren't any DST cards inside the
> machine,
> so you cannot just come up, turn everything around, and thus pick up the
> inversion that fits into your strange concept (whatever that may be - noone
> except you
> knows) for blocking that good work.
> So I'd deeply appreciate you to stop this strange hindrance policy. You
> will do nobody any favour with that strange behaviour!
> In my eyes you do not want to help at all - you just want to provoke. And
> if in the end someone insults you you seem to have won.
> But you do not win anything with your strange gestures behind other
> peoples backs, you're instead counterproductive.
> 
> And EVEN IF you write this publically you should immediately stop to do
> this behind the author's back - so I CCed Trent Piepho.
> Just to see and show him the bad methods that you are using to qualify
> other people's efforts.
> 
> > 
> > $ ps ax|grep modprobe
> >  2769 pts/0    S      0:00 modprobe dvb_bt8xx
> >  2779 pts/0    S+     0:00 grep --color modprobe
> > 
> > $ dmesg
> > DVB: registering new adapter (bttv0).
> > DVB: Unable to find symbol dst_attach()
> > Unable to handle kernel NULL pointer dereference at 00000000000002f0
> RIP:
> > <ffffffff8825f11b>{:dvb_bt8xx:dvb_bt8xx_probe+3195}
> > PGD 7cfba067 PUD 7cfc5067 PMD 0
> > Oops: 0000 [1] SMP
> > CPU 0
> > Modules linked in: dvb_bt8xx dvb_core cx8800 cx88xx bt878 usbhid dvb_pll
> > tuner bttv video_buf firmware_class ir_common i2c_algo_bit btcx_risc
> > tveeprom i2c_core pcspkr sn9c102 compat_ioctl32 videodev v4l1_compat
> v4l2_common
> > forcedeth kqemu joydev analog gameport ohci1394 ieee1394 ehci_hcd
> ohci_hcd
> > usbcore reiserfs sd_mod sata_nv libata scsi_mod
> > Pid: 1286, comm: modprobe Tainted: P      2.6.17.4 #1
> > RIP: 0010:[<ffffffff8825f11b>]
> > <ffffffff8825f11b>{:dvb_bt8xx:dvb_bt8xx_probe+3195}
> > RSP: 0018:ffff81007c239e38  EFLAGS: 00010296
> > RAX: 000000000000002b RBX: ffff81007c05a800 RCX: 0000000000000003
> > RDX: 0000000000000000 RSI: 0000000000000292 RDI: ffffffff803905bc
> > RBP: 0000000000000000 R08: 0000000000004c72 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffff81007c190000
> > R13: ffff81007c05a8d0 R14: ffff81007c05ac98 R15: ffff81007c05abc8
> > FS:  00002b8b39ddf6f0(0000) GS:ffffffff80476000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 00000000000002f0 CR3: 000000007cfc2000 CR4: 00000000000006e0
> > Process modprobe (pid: 1286, threadinfo ffff81007c238000, task
> > ffff81007dfd4960)
> > Stack: ffff81007c05acb0 ffff81007c05a870 000000717c1e31c0
> ffff81007c190198
> >        ffff81007c190000 ffffffff88261940 ffffffff88261940
> 0000000000000000
> >        0000000000518130 ffffffff8026ce95
> > Call Trace: <ffffffff8026ce95>{driver_probe_device+101}
> >        <ffffffff8026d00a>{__driver_attach+122}
> > <ffffffff8026cf90>{__driver_attach+0}
> >        <ffffffff8026c6f9>{bus_for_each_dev+73}
> > <ffffffff8026c2e8>{bus_add_driver+136}
> >        <ffffffff80152977>{sys_init_module+199}
> > <ffffffff80109d2a>{system_call+126}
> > 
> > Code: f6 04 25 f0 02 00 00 20 0f 84 01 ff ff ff e9 7d fd ff ff 66
> > RIP <ffffffff8825f11b>{:dvb_bt8xx:dvb_bt8xx_probe+3195} RSP
> > <ffff81007c239e38>
> > CR2: 00000000000002f0
> > 
> > So, those patches aren't enough to fix the issue.
> > 
> > Cheers,
> > Mauro
> > 
> > 
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> -- 
> "Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
> Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Mr. Chehab,

if your specific invented case
(read: DST card in the machine with DST modules disabled)
would be at least transparent there would be at least corresponding lines like these
part of the dmesg:

bttv: Bt8xx card found (0).
PCI: Enabling device 0000:02:0b.0 (0004 -> 0006)
ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 23 (level, low) -> IRQ 20
bttv0: Bt878 (rev 17) at 0000:02:0b.0, irq: 20, latency: 32, mmio: 0xf3000000
bttv0: detected: Pinnacle PCTV Sat [card=94], PCI subsystem ID is 11bd:001c
bttv0: using: Pinnacle PCTV Sat [card=94,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00cf47fc [init]
bttv0: using tuner=-1
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
bttv0: add subdevice "dvb0"
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
PCI: Enabling device 0000:02:0b.1 (0004 -> 0006)
ACPI: PCI Interrupt 0000:02:0b.1[A] -> GSI 23 (level, low) -> IRQ 20
bt878_probe: card id=[0x1c11bd],[ Pinnacle PCTV Sat ] has DVB functions.
bt878(0): Bt878 (rev 17) at 02:0b.1, irq: 20, latency: 32, memory: 0xf2800000
DVB: registering new adapter (bttv0).
DVB: registering frontend 0 (Conexant CX24110 DVB-S)...

But I cannot find those lines in your dmesg at all.

The biggest problem that I had with you in the past weeks is and was that you never even once offer full transparency when you are building up theses NOT TO accept patches.

And if it is only the other side (me, Trent, others) to be forced to offer transparent information BUT NOT YOU YOURSELF
then this is what I would call a deep anti-democratic behaviour.

You can neither help nor can you solve any problem continuing in that manner,
can you?

Happy reflection on your very strange methods, with the hope to do better in the future! If there is some hope - well, I doubt!

Uwe

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
