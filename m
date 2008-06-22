Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYFVTAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYFVTAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYFVTAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:00:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36214 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYFVTAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:00:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc7-git2: Reported regressions from 2.6.25
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <RzbtSgMztjP.A.jRD._spXIB@albercik>
Date: Sun, 22 Jun 2008 19:49:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note to bug reporters: If you can, please always add
kernel-testers@vger.kernel.org to the CC lists of your reports, as that will
help to filter them out of the other LKML traffic.  Also, if you report a
regression, please add '[regression]' or something similar to the subject.]

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
  2008-06-22      148       39          28
  2008-06-14      130       37          28
  2008-06-07      125       48          33
  2008-05-31      115       52          31
  2008-05-24       94       47          28
  2008-05-18       80       51          37
  2008-05-11       53       46          34


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10962
Subject		: 2.6.26-rc2 WARNING from usb-serial, and then my gps is dead
Submitter	: Helge Hafting <helge.hafting@aitel.hist.no>
Date		: 2008-06-22 18:22 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121415899320685&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10961
Subject		: 2.6.26-rc: nfsd hangs for a few sec
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2008-06-21 12:57 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121405308328004&w=4
		  http://marc.info/?l=linux-kernel&m=121412880115289&w=4
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>
		  Mel Gorman <mel@csn.ul.ie>
		  Christoph Lameter <clameter@sgi.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10960
Subject		: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2008-06-19 14:07 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121388456519637&w=4
Handled-By	: David Miller <davem@davemloft.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10959
Subject		: stuck tcp connections 2.6.26-rc7
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-06-22 18:09 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121415821219644&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10957
Subject		: pata_pcmcia with Sandisk Extreme III 8GB
Submitter	: Komuro <komurojun-mbn@nifty.com>
Date		: 2008-06-07 13:37 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121284627119861&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Dominik Brodowski <linux@dominikbrodowski.net>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10956
Subject		: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-06-22 12:56 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121413950227884&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10955
Subject		: v2.6.26-rc7: BUG task_struct: Poison overwritten
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-06-21 19:24 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121407641925121&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10954
Subject		: hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-06-21 2:05 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121401399622190&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10951
Subject		: alpha build failure
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-06-22 02:13 (1 days old)
References	: http://lkml.org/lkml/2008/6/22/18


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10923
Subject		: System turns off during wake from S3, Wake Regression from 2.6.25
Submitter	: Dionisus Torimens <djtm@gmx.net>
Date		: 2008-06-15 16:24 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10919
Subject		: [regression] display dimming is slow and laggy - Acer Travelmate 661lci
Submitter	: Maximilian Engelhardt <maxi@daemonizer.de>
Date		: 2008-06-14 22:31 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121348428828320&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10912
Subject		: Regressions in the last kernels
Submitter	: werner <werner@sys-linux.yi.org>
Date		: 2008-06-14 18:26 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121346933911641&w=4
		  http://lkml.org/lkml/2008/6/15/35


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10906
Subject		: repeatable slab corruption with LTP msgctl08
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-06-12 5:13 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=121324775927704&w=4
Handled-By	: Pekka J Enberg <penberg@cs.helsinki.fi>
		  Christoph Lameter <clameter@sgi.com>
		  Manfred Spraul <manfred@colorfullife.com>
		  Andi Kleen <andi@firstfloor.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10892
Subject		: Sometime (often) X come out blank (black screen) on cold boot - Intel chipset
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-06-10 05:33 (13 days old)
References	: http://lkml.org/lkml/2008/6/10/137


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
Subject		: x86_64 boot hang when CONFIG_NUMA=n
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-06-05 21:50 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
		  http://lkml.org/lkml/2008/6/11/355
		  http://lkml.org/lkml/2008/6/15/117
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10868
Subject		: Oops on loading ipaq module since 2.6.26, prevents use of device
Submitter	: Adam Williamson <awilliamson@mandriva.com>
Date		: 2008-06-05 17:39 (18 days old)
Handled-By	: Alan Cox <alan@redhat.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10865
Subject		: Oops trying to mount an ntfs partition on thinkpad
Submitter	: Alex Romosan <romosan@sycorax.lbl.gov>
Date		: 2008-06-05 14:47 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=121267834421414&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10862
Subject		: forcedeth: lockdep warning on ethtool -s
Submitter	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Date		: 2008-06-01 8:37 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=121230964032247&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
Subject		: 2.6.26-rc4-git2 - long pause during boot
Submitter	: Chris Clayton <chris2553@googlemail.com>
Date		: 2008-06-01 4:15 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=121229382917834&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10843
Subject		: Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-05-31 14:04 (23 days old)
References	: http://lkml.org/lkml/2008/6/7/206
		  http://lkml.org/lkml/2008/6/15/119


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10827
Subject		: 2.6.26rc4 GFS2 oops.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-27 15:44 (27 days old)
References	: http://lkml.org/lkml/2008/5/27/297


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10826
Subject		: NFS oops in 2.6.26rc4
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2008-05-27 19:04 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=121191548915522&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10821
Subject		: rt25xx: lock dependency warning, association failure, and kmalloc corruption
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-05-29 14:30 (25 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10786
Subject		: parisc: 64bit SMP does not boot on J5600
Submitter	: Domenico Andreoli <cavokz@gmail.com>
Date		: 2008-05-22 16:14 (32 days old)
References	: http://marc.info/?l=linux-kernel&m=121147328028081&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
Subject		: bug in `tty: BKL pushdown'?
Submitter	: Johannes Weiner <hannes@saeurebad.de>
Date		: 2008-05-18 2:16 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=121107706506181&w=4
		  http://lkml.org/lkml/2008/6/16/104
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10725
Subject		: USB Mass storage mount fails: Write protect on
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2008-05-16 14:55 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121095168003572&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
Subject		: powerpc: Badness seen on 2.6.26-rc2 with lockdep enabled
Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
Date		: 2008-05-14 12:57 (40 days old)
References	: http://marc.info/?l=linux-kernel&m=121076917429133&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-05 09:59 (49 days old)
References	: http://lkml.org/lkml/2008/5/5/28
Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10958
Subject		: LMSENSORS: 2.6.26-rc, enabling ACPI Termal Zone support costs sensors
Submitter	: Rene Herman <rene.herman@keyaccess.nl>
Date		: 2008-06-22 0:47 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=121409569819064&w=4
Handled-By	: Hans de Goede <j.w.r.degoede@hhs.nl>
		  Rene Herman <rene.herman@keyaccess.nl>
Patch		: http://lkml.org/lkml/2008/6/22/83


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10927
Subject		: Dell laptops: reboot instead of resume
Submitter	: Kirill A. Shutemov <kirill@shutemov.name>
Date		: 2008-06-16 07:31 (7 days old)
Handled-By	: H. Peter Anvin <hpa@kernel.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16549&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10918
Subject		: 2.6.26-rc5: SLUB debug, lockdep warning...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2008-06-14 10:54 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121344091109597&w=4
Handled-By	: Vegard Nossum <vegard.nossum@gmail.com>
		  Daniel J Blueman <daniel.blueman@gmail.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10918#c2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10860
Subject		: total system freeze at boot with 2.6.26-rc
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2008-06-05 12:38 (18 days old)
Handled-By	: Tejun Heo <htejun@gmail.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16556


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10830
Subject		: two different oopses with 2.6.26-rc4
Submitter	: Alejandro Riveira Fernández <alejandro.riveira@gmail.com>
Date		: 2008-05-28 9:50 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=121196833026310&w=4
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
		  Andrew Morton <akpm@linux-foundation.org>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://lkml.org/lkml/2008/5/20/683


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
Date		: 2008-05-27 09:23 (27 days old)
References	: http://lkml.org/lkml/2008/5/27/9
		  http://lkml.org/lkml/2008/6/14/87
Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
		  Linus Torvalds <torvalds@linux-foundation.org>
		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Patch		: http://lkml.org/lkml/2008/5/28/16


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10730
Subject		: build issue #503 for v2.6.26-rc2-433-gf26a398 : undefined reference to `request_firmware'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-05-16 17:06 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121095777616792&w=4
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
Patch		: http://marc.info/?l=linux-scsi&m=121101871800303&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10726
Subject		: x86-64 NODES_SHIFT compile failure.
Submitter	: Dave Jones <davej@codemonkey.org.uk>
Date		: 2008-05-16 12:54 (38 days old)
References	: http://lkml.org/lkml/2008/5/16/312
Handled-By	: Mike Travis <travis@sgi.com>
Patch		: http://lkml.org/lkml/2008/5/16/343


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10724
Subject		: ACPI: EC: GPE storm detected, disabling EC GPE
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-05-16 6:17 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121091875711824&w=4
		  http://lkml.org/lkml/2008/5/18/168
		  http://lkml.org/lkml/2008/5/25/195
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10493
Subject		: mips BCM47XX compile error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-04-20 17:07 (64 days old)
References	: http://lkml.org/lkml/2008/4/20/34
		  http://lkml.org/lkml/2008/5/12/30
		  http://lkml.org/lkml/2008/5/18/131
		  http://lkml.org/lkml/2008/5/31/202
		  http://lkml.org/lkml/2008/6/7/154
Patch		: http://marc.info/?l=linux-kernel&m=120876451216558&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (51 days old)
Handled-By	: Maciej W. Rozycki <macro@linux-mips.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16180


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

