Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYDQVfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYDQVfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYDQVfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:35:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbYDQVfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:35:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.25: Reported regressions from 2.6.24
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, david@lang.hm
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <OWZNsD2DjtM.A.d_C.327BIB@albercik>
References: <alpine.LFD.1.00.0804162009080.2879@woody.linux-foundation.org> <alpine.DEB.1.10.0804162120130.17133@asgard>
In-Reply-To: <alpine.DEB.1.10.0804162120130.17133@asgard>
Date: Thu, 17 Apr 2008 22:46:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As promised, below is the list of reported regressions from 2.6.24 for which
there are no fixes in 2.6.25, AFAICS.

I'm now going to start tracking regressions from 2.6.25, but bug #9832 used
for tracking the regressions from 2.6.24 will stay there, so if you report
a regression from 2.6.24 through the Bugzilla, please make it block that bug.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2008-04-17      193       17          13
  2008-04-13      194       27          22
  2008-04-07      188       29          22
  2008-03-31      177       34          31
  2008-03-27      171       38          30
  2008-03-22      159       35          31
  2008-03-17      148       38          30
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

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10421
Subject		: Filesystem failing without any warning or etc
Submitter	: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Date		: 2008-04-07 23:11 (11 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10393
Subject		: ext4 compile error on m68k
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-04-05 03:30 (13 days old)
References	: http://lkml.org/lkml/2008/4/5/19
		  http://lkml.org/lkml/2008/4/9/13
		  http://lkml.org/lkml/2008/4/13/241


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10391
Subject		: 2.6.25-rc7/8: Another resume regression
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2008-04-03 15:06 (15 days old)
References	: http://lkml.org/lkml/2008/4/3/283


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10377
Subject		: Kernel usually freezes during boot when AC is unplugged - unless CPU_IDLE=n - Asus A6JC
Submitter	: Roman Jarosz <kedgedev@centrum.cz>
Date		: 2008-04-01 16:23 (17 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10369
Subject		: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Submitter	: Chr <chunkeey@web.de>
Date		: 2008-03-30 21:09 (19 days old)
References	: http://lkml.org/lkml/2008/3/30/87
		  http://lkml.org/lkml/2008/4/13/243
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10365
Subject		: usb-storage, error reading the last 8 sectors, regression in 2.6.25-rc7
Submitter	: Sergey Dolgov <solkaa@gmail.com>
Date		: 2008-03-30 11:49 (19 days old)
References	: http://lkml.org/lkml/2008/3/30/11


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10320
Subject		: rt2x00 does not associate or give scan results
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 06:04 (24 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
Subject		: MacBookPro1,1: on resume (from console) s2ram -f -p does not anymore give me my display back
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-03-25 04:44 (24 days old)
References	: http://lkml.org/lkml/2008/4/2/496
		  http://lkml.org/lkml/2008/4/6/1
		  http://lkml.org/lkml/2008/4/9/40
		  http://lkml.org/lkml/2008/4/9/51
		  http://lkml.org/lkml/2008/4/13/73


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10300
Subject		: volume wheel does not work in 2.6.25-rc6
Submitter	: Romano Giannetti <romano.giannetti@gmail.com>
Date		: 2008-03-21 11:42 (28 days old)
References	: http://lkml.org/lkml/2008/4/9/94
		  http://lkml.org/lkml/2008/4/14/57


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10290
Subject		: [BUG] Linux 2.6.25-rc6 - kernel BUG at fs/mpage.c:476! on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-03-20 13:13 (29 days old)
References	: http://lkml.org/lkml/2008/3/20/39


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10235
Subject		: 2.6.25-rc5: Blank Screen with Intel 945
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2008-03-12 12:02 (37 days old)
References	: http://lkml.org/lkml/2008/3/12/290
		  http://lkml.org/lkml/2008/4/1/318
Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10082
Subject		: 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-20 16:01 (58 days old)
References	: http://lkml.org/lkml/2008/2/20/218
		  http://lkml.org/lkml/2008/1/18/71
		  http://lkml.org/lkml/2008/4/9/25
Handled-By	: Paul Mackerras <paulus@samba.org>
		  Nish Aravamudan <nish.aravamudan@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
Subject		: 2.6.25-rc1: volanoMark regression
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2008-02-13 10:30 (65 days old)
References	: http://lkml.org/lkml/2008/2/13/128
		  http://lkml.org/lkml/2008/3/12/52
		  http://lkml.org/lkml/2008/3/18/81
Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
		  Balbir Singh <balbir@linux.vnet.ibm.com>


Regressionn with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10427
Subject		: e1000e broke e1000
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-04-08 20:39 (10 days old)
References	: http://lkml.org/lkml/2008/4/8/256
		  http://lkml.org/lkml/2008/4/14/46
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15704&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10366
Subject		: 2.6.25-rc7: warn_on_slowpath triggered
Submitter	: Bob Tracy <rct@frus.com>
Date		: 2008-03-29 17:29 (20 days old)
References	: http://lkml.org/lkml/2008/3/29/125
Handled-By	: Björn Steinbrink <B.Steinbrink@gmx.de>
Patch		: http://lkml.org/lkml/2008/3/30/245


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10302
Subject		: 2.6.25-git regression with snd-hda-intel on Dell XPS M1330, no analog sound
Submitter	: Andre Tomt <andre@tomt.net>
Date		: 2008-03-21 20:03 (28 days old)
References	: http://lkml.org/lkml/2008/3/21/295
Handled-By	: Matthew Ranostay <mranostay@embeddedalley.com>
		  Takashi Iwai <tiwai@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15766&amp;action=view


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
Subject		: (regression) kernel/timeconst.h bugs with HZ=128
Submitter	: David Brownell <david-b@pacbell.net>
Date		: 2008-02-26 19:32 (52 days old)
References	: http://lkml.org/lkml/2008/2/26/294
Handled-By	: H. Peter Anvin <hpa@zytor.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view


For details, please visit the bug entries and follow the links given in
references.

Thanks,
Rafael

