Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYCQVhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYCQVhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYCQVh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:37:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44442 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYCQVhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:37:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jason Wu" <wenhsuan121@gmail.com>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
Date: Mon, 17 Mar 2008 22:36:31 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
References: <200803170018.52663.rjw@sisk.pl> <469a066a0803162347i54e04ddbq24a9b592c4ed1bca@mail.gmail.com>
In-Reply-To: <469a066a0803162347i54e04ddbq24a9b592c4ed1bca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803172236.33487.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 17 of March 2008, Jason Wu wrote:
> 2008/3/17, Rafael J. Wysocki <rjw@sisk.pl>:
> > This message contains a list of some regressions from 2.6.24 reported since
> > 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> > of.  If any of them have been fixed already, please let me know.
> >
> > If you know of any other unresolved regressions from 2.6.24, please let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> >
> >
> > Listed regressions statistics:
> >
> >  Date          Total  Pending  Unresolved
> >  ----------------------------------------
> >  2008-03-17      148       38          30
> >  2008-03-16      146       42          35
> >  2008-03-14      145       45          39
> >  2008-03-12      143       51          41
> >  2008-03-11      141       58          43
> >  2008-03-10      138       66          47
> >  2008-03-03      115       65          49
> >  2008-02-25       90       51          39
> >  2008-02-17       61       45          37
> >
> >
> > Unresolved regressions
> > ----------------------
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=9962
> > Subject         : mount: could not find filesystem
> > Submitter       : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > Date            : 2008-02-12 14:34 (34 days old)
> > References      : http://lkml.org/lkml/2008/2/12/91
> > Handled-By      : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >                  Yinghai Lu <yhlu.kernel@gmail.com>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=9976
> > Subject         : BUG: 2.6.25-rc1: iptables postrouting setup causes oops
> > Submitter       : Ben Nizette <bn@niasdigital.com>
> > Date            : 2008-02-12 12:46 (34 days old)
> > References      : http://lkml.org/lkml/2008/2/12/148
> > Handled-By      : Haavard Skinnemoen <hskinnemoen@atmel.com>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=9978
> > Subject         : 2.6.25-rc1: volanoMark regression
> > Submitter       : Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date            : 2008-02-13 10:30 (33 days old)
> > References      : http://lkml.org/lkml/2008/2/13/128
> >                  http://lkml.org/lkml/2008/3/12/52
> > Handled-By      : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> >                  Balbir Singh <balbir@linux.vnet.ibm.com>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=9980
> > Subject         : 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
> > Submitter       : Jasper Bryant-Greene <jasper@unix.geek.nz>
> > Date            : 2008-02-13 12:25 (33 days old)
> > References      : http://lkml.org/lkml/2008/2/13/181
> > Handled-By      : Yinghai Lu <Yinghai.Lu@sun.com>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=9983
> > Subject         : PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
> > Submitter       : Linas ®virblis <0x0007@gmail.com>
> > Date            : 2008-02-13 22:38 (33 days old)
> > References      : http://lkml.org/lkml/2008/2/13/566
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=9995
> > Subject         : 2.6.25-rc1 regression - backlight controlls do not work - ThinkPad T61
> > Submitter       : Lukas Hejtmanek <xhejtman@fi.muni.cz>
> > Date            : 2008-02-15 04:51 (31 days old)
> > Handled-By      : Zhang Rui <rui.zhang@intel.com>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10011
> > Subject         : The computer is blocked when X is started - unless max_cstate=2 - Acer Travelmate 4001 Lmi
> > Submitter       : François Valenduc <francois.valenduc@tvcablenet.be>
> > Date            : 2008-02-17 06:28 (29 days old)
> > Handled-By      : Thomas Gleixner <tglx@linutronix.de>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10027
> > Subject         : 2.6.25-rc[12] Video4Linux Bttv Regression
> > Submitter       : Bongani Hlope <bonganilinux@mweb.co.za>
> > Date            : 2008-02-17 09:36 (29 days old)
> > References      : http://lkml.org/lkml/2008/2/17/55
> > Handled-By      : Mauro Carvalho Chehab <mchehab@infradead.org>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10041
> > Subject         : 2.6.25-rc1/2 regression: first-time login into gnome fails
> > Submitter       : Romano Giannetti <romanol@upcomillas.es>
> > Date            : 2008-02-18 11:56 (28 days old)
> > References      : http://lkml.org/lkml/2008/2/18/145
> > Handled-By      : Ray Lee <ray-lk@madrabbit.org>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10051
> > Subject         : Spurious messages at boot, eventually hangs the usb subsustem
> > Submitter       : Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> > Date            : 2008-02-20 09:10 (26 days old)
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10065
> > Subject         : 2.6.25-rc2 regression - hang on suspend
> > Submitter       : Soeren Sonnenburg <kernel@nn7.de>
> > Date            : 2008-02-19 12:59 (27 days old)
> > References      : http://lkml.org/lkml/2008/2/19/165
> >                  http://lkml.org/lkml/2008/2/17/381
> > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10067
> > Subject         : TUNER_TDA8290=y, VIDEO_DEV=n build error
> > Submitter       : Toralf Förster <toralf.foerster@gmx.de>
> > Date            : 2008-02-22 10:36 (24 days old)
> > References      : http://lkml.org/lkml/2008/2/19/262
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10082
> > Subject         : 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
> > Submitter       : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > Date            : 2008-02-20 16:01 (26 days old)
> > References      : http://lkml.org/lkml/2008/2/20/218
> >                  http://lkml.org/lkml/2008/1/18/71
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10086
> > Subject         : 2.6.25-rc2 + smartd = hang
> > Submitter       : Anders Eriksson <aeriksson@fastmail.fm>
> > Date            : 2008-02-22 17:51 (24 days old)
> > References      : http://lkml.org/lkml/2008/2/22/239
> > Handled-By      : Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10093
> > Subject         : 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n - Apple
> > Submitter       : Soeren Sonnenburg <kernel@nn7.de>
> > Date            : 2008-02-23 18:55 (23 days old)
> > References      : http://lkml.org/lkml/2008/2/23/263
> >                  http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
> > Handled-By      : Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10117
> > Subject         : 2.6.25-current-git hangs on boot (pci=nommconf helps)
> > Submitter       : Soeren Sonnenburg <kernel@nn7.de>
> > Date            : 2008-02-23 18:55 (23 days old)
> > References      : http://lkml.org/lkml/2008/2/23/263
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10133
> > Subject         : INFO: possible circular locking in the resume
> > Submitter       : Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Date            : 2008-02-27 (19 days old)
> > References      : http://lkml.org/lkml/2008/2/26/479
> > Handled-By      : Gautham R Shenoy <ego@in.ibm.com>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10146
> > Subject         : 2.6.25-rc: complete lockup on boot/start of X (bisected)
> > Submitter       : Marcin Slusarz <marcin.slusarz@gmail.com>
> > Date            : 2008-03-02 20:00 (15 days old)
> > References      : http://lkml.org/lkml/2008/3/2/91
> > Handled-By      : Peter Zijlstra <a.p.zijlstra@chello.nl>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10152
> > Subject         : Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
> > Submitter       : Gabriel C <nix.or.die@googlemail.com>
> > Date            : 2008-02-24 01:31 (22 days old)
> > References      : http://lkml.org/lkml/2008/2/23/380
> >                  http://lkml.org/lkml/2008/2/24/281
> > Handled-By      : Thomas Gleixner <tglx@linutronix.de>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10156
> > Subject         : KVM &amp; Qemu crashed with infinite recursive kernel loop in the guest
> > Submitter       : Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Date            : 2008-02-28 11:25 (18 days old)
> > References      : http://lkml.org/lkml/2008/2/28/106
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10172
> > Subject         : kvm: INFO: inconsistent lock state
> > Submitter       : Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Date            : 2008-03-05 03:26 (12 days old)
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10190
> > Subject         : [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
> > Submitter       : Tarkan Erimer <tarkan@netone.net.tr>
> > Date            : 2008-03-05 05:01 (12 days old)
> > References      : http://www.ussg.iu.edu/hypermail/linux/kernel/0803.0/1867.html
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10203
> > Subject         : 2.6.25 IOMMU breaks DMA for b43 on x86_64
> > Submitter       : Christian Casteyde <casteyde.christian@free.fr>
> > Date            : 2008-03-09 00:55 (8 days old)
> > Handled-By      : Michael Buesch <mb@bu3sch.de>
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10207
> > Subject         : INFO: task mount:11202 blocked for more than 120 seconds
> > Submitter       : Christian Kujau <lists@nerdbynature.de>
> > Date            : 2008-03-07 21:32 (10 days old)
> > References      : http://lkml.org/lkml/2008/3/7/308
> >                  http://lkml.org/lkml/2008/3/9/186
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10211
> > Subject         : drivers/media/video/cx2341x.c: undefined references
> > Submitter       : Toralf Förster <toralf.foerster@gmx.de>
> > Date            : 2008-03-07 13:48 (10 days old)
> > References      : http://lkml.org/lkml/2008/3/7/168
> >
> I think patch of Mauro Carvalho Chehab can fix this bug.
> http://linuxtv.org/hg/v4l-dvb/rev/ba1a6a7bd53b

Thanks, I updated the entry.

Rafael
