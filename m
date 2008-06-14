Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYFNVNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYFNVNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYFNVMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:12:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50249 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbYFNVMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:12:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc6-git2: Reported regressions from 2.6.25
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
Date: Sat, 14 Jun 2008 22:04:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.25, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.25, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-06-14      130       37          28
  2008-06-07      125       48          33
  2008-05-31      115       52          31
  2008-05-24       94       47          28
  2008-05-18       80       51          37
  2008-05-11       53       46          34


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10912
Subject		: Regressions in the last kernels
Submitter	: werner <werner@sys-linux.yi.org>
Date		: 2008-06-14 18:26 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121346933911641&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10908
Subject		: IPF Montvale machine panic when running a network-relevent testing
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-06-13 8:19 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121334523711437&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10906
Subject		: repeatable slab corruption with LTP msgctl08
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-06-12 5:13 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121324775927704&w=4
Handled-By	: Pekka J Enberg <penberg@cs.helsinki.fi>
		  Christoph Lameter <clameter@sgi.com>
		  Manfred Spraul <manfred@colorfullife.com>
		  Andi Kleen <andi@firstfloor.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10903
Subject		: ssh connections hang with 2.6.26-rc5
Submitter	: Didier Raboud <didier@raboud.com>
Date		: 2008-06-13 02:39 (2 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10892
Subject		: Sometime (often) X come out blank (black screen) on cold boot - Intel chipset
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-06-10 05:33 (5 days old)
References	: http://lkml.org/lkml/2008/6/10/137


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
Subject		: x86_64 boot hang when CONFIG_NUMA=n
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-06-05 21:50 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
		  http://lkml.org/lkml/2008/6/11/355
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10868
Subject		: Oops on loading ipaq module since 2.6.26, prevents use of device
Submitter	: Adam Williamson <awilliamson@mandriva.com>
Date		: 2008-06-05 17:39 (10 days old)
Handled-By	: Alan Cox <alan@redhat.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10866
Subject		: /dev/rtc was missing until I disabled CONFIG_RTC_CLASS
Submitter	: Lior Dotan <liodot@gmail.com>
Date		: 2008-06-05 15:04 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121267834521432&w=4
		  http://marc.info/?l=linux-kernel&amp;m=121267834521432&amp;w=4
		  http://marc.info/?l=linux-kernel&amp;m=121267834521432&amp;w=4
		  http://marc.info/?l=linux-kernel&amp;m=121267834521432&amp;w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10865
Subject		: i get the following oops trying to mount an ntfs partition on thinkpad
Submitter	: Alex Romosan <romosan@sycorax.lbl.gov>
Date		: 2008-06-05 14:47 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=121267834421414&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10864
Subject		: [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
Submitter	: Németh Márton <nm127@freemail.hu>
Date		: 2008-06-03 5:18 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121247101601790&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10862
Subject		: forcedeth: lockdep warning on ethtool -s
Submitter	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Date		: 2008-06-01 8:37 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=121230964032247&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
Subject		: 2.6.26-rc4-git2 - long pause during boot
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2008-06-01 4:15 (14 days old)
References	: http://marc.info/?l=linux-kernel&m=121229382917834&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10860
Subject		: total system freeze at boot with 2.6.26-rc
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-06-05 12:38 (10 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10843
Subject		: Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-31 14:04 (15 days old)
References	: http://lkml.org/lkml/2008/6/7/206


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10827
Subject		: 2.6.26rc4 GFS2 oops.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-27 15:44 (19 days old)
References	: http://lkml.org/lkml/2008/5/27/297


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10826
Subject		: NFS oops in 2.6.26rc4
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-27 19:04 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=121191548915522&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
Subject		: rt25xx: lock dependency warning, association failure, and kmalloc corruption
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 14:30 (17 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10819
Subject		: Fatal DMA error with b43 driver since 2.6.26
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 13:16 (17 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10799
Subject		: sky2 general protection fault
Submitter	: Nicolas Mailhot <Nicolas.Mailhot@LaPoste.net>
Date		: 2008-05-26 11:05 (20 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10786
Subject		: 2.6.26-rc3 64bit SMP does not boot on J5600
Submitter	: Domenico Andreoli <cavokz@gmail.com>
Date		: 2008-05-22 16:14 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=121147328028081&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10764
Subject		: some serial configurations are now broken
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2008-05-20 7:35 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=121126931810706&w=2
Handled-By	: Javier Herrero <jherrero@hvsistemas.es>
		  Russell King <rmk+lkml@arm.linux.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
Subject		: Write protect on on
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2008-05-16 14:55 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=121095168003572&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=121076917429133&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10711
Subject		: BUG: unable to handle kernel paging request - scsi_bus_uevent
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-14 11:23 (32 days old)
References	: http://lkml.org/lkml/2008/5/14/111


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10642
Subject		: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-07 16:03 (39 days old)
References	: http://lkml.org/lkml/2008/5/7/48


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (41 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (43 days old)


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10905
Subject		: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
Submitter	: Miquel van Smoorenburg <miquels@cistron.nl>
Date		: 2008-05-21 13:30 (25 days old)
References	: http://lkml.org/lkml/2008/5/21/131
		  http://lkml.org/lkml/2008/6/12/121
Handled-By	: Glauber Costa <gcosta@redhat.com>
		  Andi Kleen <andi@firstfloor.org>
		  Miquel van Smoorenburg <mikevs@xs4all.net>
Patch		: http://lkml.org/lkml/2008/5/28/42


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10830
Subject		: two different oopses with 2.6.26-rc4
Submitter	: Alejandro Riveira Fernández <alejandro.riveira@gmail.com>
Date		: 2008-05-28 9:50 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121196833026310&w=4
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
		  Andrew Morton <akpm@linux-foundation.org>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://lkml.org/lkml/2008/5/20/683


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10828
Subject		: [2.6.25-git18 =&gt; 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
Date		: 2008-05-04 10:24 (42 days old)
References	: http://lkml.org/lkml/2008/5/4/37
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  H. Peter Anvin <hpa@zytor.com>
		  Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2008/5/29/371


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-27 09:23 (19 days old)
References	: http://lkml.org/lkml/2008/5/27/9
		  http://lkml.org/lkml/2008/6/14/87
Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
		  Linus Torvalds <torvalds@linux-foundation.org>
		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: http://lkml.org/lkml/2008/5/28/16


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10794
Subject		: mips: CONF_CM_DEFAULT build error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-05-25 10:11 (21 days old)
References	: http://lkml.org/lkml/2008/5/25/168
		  http://lkml.org/lkml/2008/6/11/295
Patch		: http://lkml.org/lkml/2008/6/1/125


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10730
Subject		: build issue #503 for v2.6.26-rc2-433-gf26a398 : undefined reference to `request_firmware'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-16 17:06 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=121095777616792&w=4
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
Patch		: http://marc.info/?l=linux-scsi&m=121101871800303&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
Subject		: x86-64 NODES_SHIFT compile failure.
Submitter	: Dave Jones <davej@codemonkey.org.uk>
Date		: 2008-05-16 12:54 (30 days old)
References	: http://lkml.org/lkml/2008/5/16/312
Handled-By	: Mike Travis <travis@sgi.com>
Patch		: http://lkml.org/lkml/2008/5/16/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10724
Subject		: ACPI: EC: GPE storm detected, disabling EC GPE
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-16 6:17 (30 days old)
References	: http://marc.info/?l=linux-kernel&m=121091875711824&w=4
		  http://lkml.org/lkml/2008/5/18/168
		  http://lkml.org/lkml/2008/5/25/195
		  http://lkml.org/lkml/2008/5/25/195
Patch		:  debug EC GPE
		   debug EC GPE
		   debug EC GPE
		   debug EC GPE
		  http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
		   debug EC GPE</a>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10493
Subject		: mips BCM47XX compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:07 (56 days old)
References	: http://lkml.org/lkml/2008/4/20/34
		  http://lkml.org/lkml/2008/5/12/30
		  http://lkml.org/lkml/2008/5/18/131
		  http://lkml.org/lkml/2008/5/31/202
		  http://lkml.org/lkml/2008/6/7/154
Patch		: http://marc.info/?l=linux-kernel&m=120876451216558&w=2


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.25,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=10492

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

