Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbYCPAON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbYCPAON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 20:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYCPAOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 20:14:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34104 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbYCPAN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 20:13:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc5-git5: Reported regressions from 2.6.24
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 16 Mar 2008 01:12:50 +0100
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <200803160112.50874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.24 reported since
2.6.25-rc1 was released, for which there are no fixes in the mainline I know
of.  If any of them have been fixed already, please let me know.

If you know of any other unresolved regressions from 2.6.24, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-03-16      146       42          35
  2008-03-14      145       45          39
  2008-03-12      143       51          41
  2008-03-11      141       58          43
  2008-03-10      138       66          47
  2008-03-03      115       65          49
  2008-02-25       90       51          39
  2008-02-17       61       45          37


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9958
Subject		: parisc compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-08 01:12 (37 days old)
References	: http://lkml.org/lkml/2008/2/7/572
Handled-By	: Kyle McMartin <kyle@mcmartin.ca>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9962
Subject		: mount: could not find filesystem
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-12 14:34 (33 days old)
References	: http://lkml.org/lkml/2008/2/12/91
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
		  Yinghai Lu <yhlu.kernel@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9976
Subject		: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
Submitter	: Ben Nizette <bn@niasdigital.com>
Date		: 2008-02-12 12:46 (33 days old)
References	: http://lkml.org/lkml/2008/2/12/148
Handled-By	: Haavard Skinnemoen <hskinnemoen@atmel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
Subject		: 2.6.25-rc1: volanoMark 45% regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-13 10:30 (32 days old)
References	: http://lkml.org/lkml/2008/2/13/128
		  http://lkml.org/lkml/2008/3/12/52
Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
		  Balbir Singh <balbir@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9980
Subject		: 2.6.25-rc1 on Sun Ultra 40- HPET clocksource which causes it to hang
Submitter	: Jasper Bryant-Greene <jasper@unix.geek.nz>
Date		: 2008-02-13 12:25 (32 days old)
References	: http://lkml.org/lkml/2008/2/13/181
Handled-By	: Yinghai Lu <Yinghai.Lu@sun.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
Submitter	: Linas ®virblis <0x0007@gmail.com>
Date		: 2008-02-13 22:38 (32 days old)
References	: http://lkml.org/lkml/2008/2/13/566


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9984
Subject		: problem with starting 2.6.25-rc1 and latest git
Submitter	: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date		: 2008-02-13 23:16 (32 days old)
References	: http://lkml.org/lkml/2008/2/13/587


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9995
Subject		: 2.6.25-rc1 regression - backlight controlls do not work - ThinkPad T61
Submitter	: Lukas Hejtmanek <xhejtman@fi.muni.cz>
Date		: 2008-02-15 04:51 (30 days old)
Handled-By	: Zhang Rui <rui.zhang@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10011
Subject		: The computer is blocked when X is started - unless max_cstate=2 - Acer Travelmate 4001 Lmi
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-02-17 06:28 (28 days old)
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10027
Subject		: 2.6.25-rc[12] Video4Linux Bttv Regression
Submitter	: Bongani Hlope <bonganilinux@mweb.co.za>
Date		: 2008-02-17 09:36 (28 days old)
References	: http://lkml.org/lkml/2008/2/17/55
Handled-By	: Mauro Carvalho Chehab <mchehab@infradead.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10041
Subject		: 2.6.25-rc1/2 regression: first-time login into gnome fails
Submitter	: Romano Giannetti <romanol@upcomillas.es>
Date		: 2008-02-18 11:56 (27 days old)
References	: http://lkml.org/lkml/2008/2/18/145
Handled-By	: Ray Lee <ray-lk@madrabbit.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10051
Subject		: Spurious messages at boot, eventually hangs the usb subsustem
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-02-20 09:10 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10061
Subject		: Hang in md5_resync
Submitter	: Steinar H. Gunderson <sgunderson@bigfoot.com>
Date		: 2008-02-21 13:13 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10065
Subject		: 2.6.25-rc2 regression - hang on suspend
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-19 12:59 (26 days old)
References	: http://lkml.org/lkml/2008/2/19/165
		  http://lkml.org/lkml/2008/2/17/381
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10067
Subject		: TUNER_TDA8290=y, VIDEO_DEV=n build error
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-02-22 10:36 (23 days old)
References	: http://lkml.org/lkml/2008/2/19/262


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10082
Subject		: [BUG] 2.6.25-rc2-git4 - Regression Kernel oops while running kernbench and tbench on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-20 16:01 (25 days old)
References	: http://lkml.org/lkml/2008/2/20/218
		  http://lkml.org/lkml/2008/1/18/71


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10084
Subject		: 2.6.25-rc2-git4 BUG: sysfs_readdir
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-02-21 17:25 (24 days old)
References	: http://lkml.org/lkml/2008/2/21/212
Handled-By	: Greg KH <greg@kroah.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10086
Subject		: 2.6.25-rc2 + smartd = hang
Submitter	: Anders Eriksson <aeriksson@fastmail.fm>
Date		: 2008-02-22 17:51 (23 days old)
References	: http://lkml.org/lkml/2008/2/22/239
Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10093
Subject		: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n - Apple
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (22 days old)
References	: http://lkml.org/lkml/2008/2/23/263
		  http://marc.info/?l=linux-acpi&amp;m=120387537018467&amp;w=4
Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10097
Subject		: SMP BUG in __nf_conntrack_find
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-02-25 10:44 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10117
Subject		: 2.6.25-current-git hangs on boot (pci=nommconf helps)
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-02-23 18:55 (22 days old)
References	: http://lkml.org/lkml/2008/2/23/263


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10133
Subject		: INFO: possible circular locking in the resume
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-27 (18 days old)
References	: http://lkml.org/lkml/2008/2/26/479
Handled-By	: Gautham R Shenoy <ego@in.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10146
Subject		: 2.6.25-rc: complete lockup on boot/start of X (bisected)
Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
Date		: 2008-03-02 20:00 (14 days old)
References	: http://lkml.org/lkml/2008/3/2/91
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10152
Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-02-24 01:31 (21 days old)
References	: http://lkml.org/lkml/2008/2/23/380
		  http://lkml.org/lkml/2008/2/24/281
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10156
Subject		: KVM &amp; Qemu crashed with infinite recursive kernel loop in the guest
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-02-28 11:25 (17 days old)
References	: http://lkml.org/lkml/2008/2/28/106


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10172
Subject		: INFO: inconsistent lock state
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-03-05 03:26 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10190
Subject		: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
Submitter	: Tarkan Erimer <tarkan@netone.net.tr>
Date		: 2008-03-05 05:01 (11 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0803.0/1867.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10203
Subject		: 2.6.25 IOMMU breaks DMA for b43 on x86_64
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-03-09 00:55 (7 days old)
Handled-By	: Michael Buesch <mb@bu3sch.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
Subject		: INFO: task mount:11202 blocked for more than 120 seconds
Submitter	: Christian Kujau <lists@nerdbynature.de>
Date		: 2008-03-07 21:32 (9 days old)
References	: http://lkml.org/lkml/2008/3/7/308
		  http://lkml.org/lkml/2008/3/9/186


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10211
Subject		: build #408 issue for v2.6.25-rc4-56-gd7fe321 in cx2341x_ctrl_get_menu
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-03-07 13:48 (9 days old)
References	: http://lkml.org/lkml/2008/3/7/168


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10232
Subject		: intel mtrr fixups apparently broke display and e1000 probe
Submitter	: Stephen Gran <steve@lobefin.net>
Date		: 2008-03-12 08:37 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10234
Subject		: [regression] pciehp hang on hp ia64 rx6600
Submitter	: Alex Chiang <achiang@hp.com>
Date		: 2008-03-12 00:47 (4 days old)
References	: http://lkml.org/lkml/2008/3/12/31
Handled-By	: Mark Lord <mlord@pobox.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10235
Subject		: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2008-03-12 12:02 (4 days old)
References	: http://lkml.org/lkml/2008/3/12/290
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10238
Subject		: netconsole still hangs
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-03-12 23:14 (4 days old)
References	: http://marc.info/?t=120536379200004&amp;r=1&amp;w=2
Handled-By	: David Miller <davem@davemloft.net>
		  Stephen Hemminger <shemminger@linux-foundation.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10242
Subject		: rm command hangs
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-03-14 05:47 (2 days old)


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9969
Subject		: 2.6.24-git15 Keyboard Issue?
Submitter	: Chris Holvenstot <cholvenstot@comcast.net>
Date		: 2008-02-06 14:02 (39 days old)
References	: http://lkml.org/lkml/2008/2/6/100
		  http://lkml.org/lkml/2008/2/13/82
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://lkml.org/lkml/2008/2/15/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10013
Subject		: tbench regression in 2.6.25-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-15 02:52 (30 days old)
References	: http://lkml.org/lkml/2008/2/14/546
Handled-By	: Eric Dumazet <dada1@cosmosbay.com>
		  David Miller <davem@davemloft.net>
		  Zhang Yanmin <yanmin.zhang@intel.com>
Patch		: http://lkml.org/lkml/2008/2/18/66
		  http://lkml.org/lkml/2008/2/18/117
		  http://lkml.org/lkml/2008/2/20/83


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10016
Subject		: cobalt_btns.c &lt;-&gt; struct platform_device compile error
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-17 12:12 (28 days old)
References	: http://lkml.org/lkml/2008/2/17/293
Handled-By	: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Patch		: http://lkml.org/lkml/2008/3/9/25


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10017
Subject		: cdev removal broke cobalt_btns.c compilation
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-02-17 12:14 (28 days old)
References	: http://lkml.org/lkml/2008/2/17/295
Handled-By	: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Patch		: http://lkml.org/lkml/2008/3/9/25


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
Subject		: (regression) kernel/timeconst.h bugs with HZ=128
Submitter	: David Brownell <david-b@pacbell.net>
Date		: 2008-02-26 19:32 (19 days old)
References	: http://lkml.org/lkml/2008/2/26/294
Handled-By	: H. Peter Anvin <hpa@zytor.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10186
Subject		: SCSI_AIC94XX must depend on SCSI
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-03-06 19:09 (10 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=120483073617232&amp;w=2
Handled-By	: Adrian Bunk <bunk@kernel.org>
Patch		: http://marc.info/?l=linux-kernel&amp;m=120483499725928&amp;w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10210
Subject		: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on pata_ali
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2008-03-08 22:46 (8 days old)
References	: http://lkml.org/lkml/2008/3/8/123
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://lkml.org/lkml/2008/3/10/69


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.24,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9832

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
