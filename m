Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZDFVjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZDFVjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZDFVjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:39:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbZDFVjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:39:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.29-git13: Reported regressions from 2.6.28
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
Date: Mon,  6 Apr 2009 20:54:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Notes:
* Some new regressions from 2.6.28 have been reported since the release of
  2.6.29, so here's an update of the regression list.
* I could have missed some fixes due to the large amounts of stuff merged
  recently.  Please have a look at the list and let me know if I can drop
  anything from it.
* I'm not going to track regressions from 2.6.27 any more.
* Next time I'll list regressions from 2.6.29 (after 2.6.30-rc1) and new
  regressions from 2.6.28 (if any) will be appended to the list below as
  "regressions introduced between 2.6.28 and 2.6.29".]

This message contains a list of some regressions from 2.6.28, for which there
are no fixes in the mainline I know of.  If any of them have been fixed already,
please let me know.

If you know of any other unresolved regressions from 2.6.28, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic reply to
this message with CCs to the people involved in reporting and handling the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-04-06      142       37          31
  2009-03-21      128       29          26
  2009-03-14      124       36          32
  2009-03-03      108       33          28
  2009-02-24       95       32          24
  2009-02-14       85       33          27
  2009-02-08       82       45          36
  2009-02-04       66       51          39
  2009-01-20       38       35          27
  2009-01-11       13       13          10


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13019
Subject		: /proc/<pid>/maps offset output broken in 2.6.29
Submitter	: "Chris Friesen" <cfriesen@nortel.com>
Date		: 2009-04-01 23:18 (6 days old)
References	: http://marc.info/?l=linuxppc-embedded&m=123862902916059&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13018
Subject		: 2.6.29 on MacBook 2,1 fails to reboot
Submitter	: Trenton Adams <trenton.d.adams@gmail.com>
Date		: 2009-03-30 2:04 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123837870307249&w=4
Handled-By	: "Morten P.D. Stevens" <mstevens@win-professional.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13017
Subject		: ATA bus errors on resume
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-03-25 5:19 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=123795841615989&w=4
Handled-By	: Tejun Heo <htejun@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13015
Subject		: pppoe over ethernet
Submitter	: Detlef Tschirschky <detlef.tschirschky@gmx.de>
Date		: 2009-03-25 21:28 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=123801663105671&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13001
Subject		: PCI-DMA: Out of IOMMU space
Submitter	:  <optimusgd@gmail.com>
Date		: 2009-04-03 09:30 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12980
Subject		: lockup in X.org
Submitter	: Marcus Better <marcus@better.se>
Date		: 2009-03-31 08:58 (7 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12975
Subject		: ata2:   lots of error messages, but OS still running well
Submitter	: Peter Teoh <htmldeveloper@gmail.com>
Date		: 2009-03-30 08:03 (8 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12971
Subject		: "tg3 transmit timed out" when transmitting at high bitrate
Submitter	: Nikolay <dobrev666@gmail.com>
Date		: 2009-03-29 18:02 (9 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12961
Subject		: Kernel panics in early boot: IO-APIC + timer doesn't work
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2009-03-28 19:00 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8d6f0c8214928f7c5083dd54ecb69c5d615b516e


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12947
Subject		: r128: system hangs when X is started with DRI enabled
Submitter	: Jos van der Ende <seraph@xs4all.nl>
Date		: 2009-03-26 16:14 (12 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12909
Subject		: boot/kernel init duration regression from 2.6.28
Submitter	: CaT <cat@zip.com.au>
Date		: 2009-03-16 10:25 (22 days old)
References	: http://marc.info/?l=linux-kernel&m=123720083515950&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12908
Subject		: acpi_ex_extract_from_field -- div by zero
Submitter	: Jiri Slaby <jirislaby@gmail.com>
Date		: 2009-03-15 10:47 (23 days old)
References	: http://marc.info/?l=linux-kernel&m=123711408225013&w=4
Handled-By	: Lin Ming <ming.m.lin@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12899
Subject		: Crash in i915.ko: i915_driver_irq_handler
Submitter	: Helge Bahmann <helge.bahmann@secunet.com>
Date		: 2009-03-20 07:13 (18 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12872
Subject		: pwc mmap always fails with EAGAIN
Submitter	: Markus <M4rkusXXL@web.de>
Date		: 2009-03-14 16:42 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=123704902201378&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12871
Subject		: usb bluetooth crashes system
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-03-10 11:23 (28 days old)
References	: http://marc.info/?l=linux-kernel&m=123668450400940&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12867
Subject		: 2.6.29-rc7 broke r8169 MAC on Thecus n2100 ARM board
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-03-09 20:29 (29 days old)
References	: http://marc.info/?l=linux-kernel&m=123663065403760&w=4
Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12861
Subject		: Xorg fails to start "Failed to allocate space for kernel memory manager"
Submitter	: Emil Karlson <jkarlson@cc.hut.fi>
Date		: 2009-03-12 12:06 (26 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12836
Subject		: 2.6.29-rc breaks STD using Intel 945
Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date		: 2009-03-04 19:20 (34 days old)
References	: http://marc.info/?l=linux-kernel&m=123619451406192&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809
Subject		: iozone regression with 2.6.29-rc6
Submitter	: Lin Ming <ming.m.lin@intel.com>
Date		: 2009-02-27 9:13 (39 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cf6e7d83bf334cc5916137862c920a97aabc018
References	: http://marc.info/?l=linux-kernel&m=123572630504360&w=4
		  http://lkml.org/lkml/2009/3/14/265
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12792
Subject		: 2.6.29-rc6-git4 boot failure
Submitter	: "Sachin P. Sant" <sachinp@in.ibm.com>
Date		: 2009-02-27 23:19 (39 days old)
References	: http://ozlabs.org/pipermail/linuxppc-dev/2009-February/068771.html


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12778
Subject		: suspend regression from 29rc5 to 29rc6
Submitter	: yury <urykhy@gmail.com>
Date		: 2009-02-25 09:25 (41 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12771
Subject		: Oops in i915_gem_flush
Submitter	: Kalev Lember <kalev@colleduc.ee>
Date		: 2009-02-24 08:35 (42 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
Subject		: i915 VT switch with AIGLX causes X lock up
Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
Date		: 2009-02-21 15:38 (45 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12763
Subject		: Different cpu MHz values for processor0 and processor1
Submitter	: "Matthew A. Bockol" <mbockol@carleton.edu>
Date		: 2009-02-21 5:42 (45 days old)
References	: http://marc.info/?l=linux-kernel&m=123519687807246&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12705
Subject		: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Submitter	: Nico Schottelius <nico-linux-20090213@schottelius.org>
Date		: 2009-02-13 9:33 (53 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e806b4957412bf472d826bd8cc571da041248799
References	: http://marc.info/?l=linux-kernel&m=123451768406825&w=4
		  http://marc.info/?l=linux-kernel&m=123479975503827&w=2
Handled-By	: Len Brown <lenb@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12681
Subject		: s2ram: fails to wake up on Acer Extensa 4220 (SMP disabled)
Submitter	: Orivej Desh <smpuj@bk.ru>
Date		: 2009-02-09 13:01 (57 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1cfe62c8010ac56e1bd3827e30386a87cc2f3594


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12670
Subject		: BUG: unable to handle kernel paging request at pin_to_kill+0x21
Submitter	: Alessandro Bono <alessandro.bono@gmail.com>
Date		: 2009-02-08 11:04 (58 days old)
References	: http://marc.info/?l=linux-kernel&m=123409113223833&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12668
Subject		: USB flash disk surprise disconnect
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2009-02-08 10:21 (58 days old)
References	: http://marc.info/?l=linux-kernel&m=123408851821292&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12574
Subject		: possible circular locking dependency detected
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2009-01-29 11:35 (68 days old)
References	: http://lkml.org/lkml/2009/2/9/205


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12499
Subject		: Problem with using bluetooth adaper connected to usb port
Submitter	: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Date		: 2009-01-13 18:34 (84 days old)
References	: http://marc.info/?l=linux-kernel&m=123187185426236&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12490
Subject		: ath5k related kernel panic in 2.6.29-rc1
Submitter	: "Sergey S. Kostyliov" <rathamahata@gmail.com>
Date		: 2009-01-12 7:38 (85 days old)
References	: http://marc.info/?l=linux-kernel&m=123174591509586&w=4
Handled-By	: Bob Copeland <me@bobcopeland.com>


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13027
Subject		: Resume after hibernation regression in forcedeth
Submitter	: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Date		: 2009-03-27 20:09 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=123818507814476&w=4
Handled-By	: Ed Swierk <eswierk@aristanetworks.com>
Patch		: http://marc.info/?l=linux-kernel&m=123878076717061&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13026
Subject		: cs5536 is broken
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2009-04-06 18:11 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=123904159829771&w=4
Handled-By	: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Patch		: http://marc.info/?l=linux-kernel&m=123904273731477&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13016
Subject		: consistent oops from request_key in 2.6.29
Submitter	: Jeff Layton <jlayton@redhat.com>
Date		: 2009-03-31 12:45 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=123850360107293&w=4
Handled-By	: David Howells <dhowells@redhat.com>
Patch		: http://marc.info/?l=linux-kernel&m=123852150806814&w=4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12870
Subject		: 2.6.29-rc "TKIP: replay detected" regression
Submitter	: Hugh Dickins <hugh@veritas.com>
Date		: 2009-03-11 12:07 (27 days old)
References	: http://marc.info/?l=linux-kernel&m=123677337219148&w=4
Handled-By	: "John W. Linville" <linville@tuxdriver.com>
Patch		: http://marc.info/?l=linux-wireless&m=123678463704691&w=2


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12671
Subject		: uvc_status_cleanup(): undefined reference to `input_unregister_device'
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2009-02-08 14:58 (58 days old)
References	: http://marc.info/?l=linux-kernel&m=123410529909318&w=4
Handled-By	: Randy Dunlap <randy.dunlap@oracle.com>
Patch		: http://lkml.org/lkml/2009/2/15/172


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12667
Subject		: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
Submitter	: Paul Collins <paul@burly.ondioline.org>
Date		: 2009-01-21 7:15 (76 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c5745aa380efb6417b5681104b007c8612fb496
References	: http://marc.info/?l=linux-kernel&m=123252215315106&w=4
Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Patch		: http://lkml.org/lkml/2009/2/16/78


For details, please visit the bug entries and follow the links given in
references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.28,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=12398

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael

