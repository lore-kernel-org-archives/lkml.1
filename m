Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbYALVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbYALVDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYALVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:03:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbYALVDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:03:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc7-git4: Reported regressions from 2.6.23
Date: Sat, 12 Jan 2008 22:05:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801122205.34871.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC: Would that be useful if I sent regression-fixing patches, CCed to the
appropriate maintainers/lists, along with the reports?]

This message contains a list of some regressions from 2.6.23 reported since
2.6.24-rc1 was released, for which there are no fixes in the mainline I know
of.  If any of them have been fixed already, please let me know.

If you know of any other unresolved regressions from 2.6.23, please let me know
either and I'll add them to the list.  Also, please let me know if any of the
entries below are invalid.

Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  Today           150       28          14
  2008-01-05      139       28          15
  2008-01-01      139       38          23
  2007-12-21      118       21          13
  2007-12-18      115       29          15
  2007-12-12      106       31          17
  2007-12-08       98       29          19
  2007-12-01       85       29          18
  2007-11-24       75       25          21
  2007-11-19       68       26          21
  2007-11-17       65       25          20


Unresolved regressions
----------------------

Subject		: EHCI causes system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2007-10-28 14:56
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
		  David Brownell <david-b@pacbell.net>
		  Alan Stern <stern@rowland.harvard.edu>
Workaround	: http://bugzilla.kernel.org/show_bug.cgi?id=9258#c30


Subject		: SError: { DevExch } occuring and causing disruption
Submitter	: Avuton Olrich <avuton@gmail.com>
Date		: 2007-11-15 22:39
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9393
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Mark Lord <mlord@pobox.com>


Subject		: BUG: bad unlock balance detected!
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:17
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9542
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>


Subject		: Could not set non-blocking flag with 2.6.24-rc5
Submitter	: Tino Keitel <tino.keitel@gmx.de>
Date		: 2007-12-13 16:27
References	: http://lkml.org/lkml/2007/12/13/392
		  http://bugzilla.kernel.org/show_bug.cgi?id=9557
Handled-By	: Linus Torvalds <torvalds@linux-foundation.org>


Subject		: swapping in 2.6.24-rc5-git3
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Date		: 2007-12-17 14:04
References	: http://lkml.org/lkml/2007/12/17/98
		  http://bugzilla.kernel.org/show_bug.cgi?id=9592
Handled-By	: Jan Kara <jack@suse.cz>


Subject		: Problems on booting
Submitter	: "werner" <werner@copaya.yi.org>
Date		: 2007-12-22 14:29
References	: http://lkml.org/lkml/2007/12/22/110
		  http://bugzilla.kernel.org/show_bug.cgi?id=9621


Subject		: ACPI or radeon: spontaneous reboot regression
Submitter	: Matt Mackall <mpm@selenic.com>
Date		: 2007-12-22 16:09
References	: http://lkml.org/lkml/2007/12/22/139
		  http://bugzilla.kernel.org/show_bug.cgi?id=9624
Handled-By	: Len Brown <lenb@kernel.org>


Subject		: iptables won't work
Submitter	: Kristoffer Malmström <malmis@malmis.com>
Date		: 2007-12-28
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9657
Handled-By	: Patrick McHardy <kaber@trash.net>


Subject		: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
Submitter	: Erez Zadok <ezk@cs.sunysb.edu>
Date		: 2007-12-24 18:02
References	: http://lkml.org/lkml/2007/12/24/107
		  http://bugzilla.kernel.org/show_bug.cgi?id=9670


Subject		: kexec buffer error
Submitter	: Randy Dunlap <rdunlap@xenotime.net>
Date		: 2008-01-04 22:54
References	: http://lkml.org/lkml/2008/1/4/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9693


Subject		: wake on lan fails with sky2 module
Submitter	: cpo <supersud501@yahoo.de>
Date		: 2008-01-09 13:05
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9721
		  http://marc.info/?t=119992349300001&r=1&w=4
Handled-By	: Stephen Hemminger <shemminger@linux-foundation.org>


Subject		: psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
Submitter	: "Vegard Nossum" <vegard.nossum@gmail.com>
Date		: 2007-11-14 21:26
References	: http://lkml.org/lkml/2007/11/14/363
		  http://bugzilla.kernel.org/show_bug.cgi?id=9727


Subject		: 2.6.24-rc7 -- WARNING: at kernel/lockdep.c:2662 check_flags()
Submitter	: "Miles Lane" <miles.lane@gmail.com>
Date		: 2008-01-07 04:34
References	: http://lkml.org/lkml/2008/1/6/313
		  http://bugzilla.kernel.org/show_bug.cgi?id=9737
Handled-By	: Ingo Molnar <mingo@elte.hu>


Subject		: regression: 100% io-wait with 2.6.24-rcX
Submitter	: Joerg Platte <lists@naasa.net>
Date		: 2008-01-07 11:51
References	: http://lkml.org/lkml/2008/1/7/70
		  http://bugzilla.kernel.org/show_bug.cgi?id=9738
Handled-By	: Fengguang Wu <wfg@mail.ustc.edu.cn>


Regressions with patches
------------------------

Subject		: [2.6.24-rc6] pdflush still stuck in D state regression
Submitter	: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Date		: 2007-11-02 09:54
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9291
Handled-By	: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14219&action=view


Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
Submitter	: Roland Dreier <rdreier@cisco.com>
Date		: 2007-11-08 14:55
References	: http://lkml.org/lkml/2007/11/8/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/11/16/66


Subject		: jiffies counter leaps in 2.6.24-rc3
Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
Date		: 2007-11-29 08:36
References	: http://lkml.org/lkml/2007/11/24/53
		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/12/7/132


Subject		: Battery shows up twice in kpowersave
Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date		: 2007-12-03 12:06
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9494
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14137&action=view


Subject		: 2.6.24-rc4 hwmon it87 probe fails
Submitter	: Mike Houston <mikeserv@bmts.com>
Date		: 2007-12-06 17:10
References	: http://lkml.org/lkml/2007/12/4/466
		  http://bugzilla.kernel.org/show_bug.cgi?id=9514
Handled-By	: Shaohua Li <shaohua.li@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14267&action=view


Subject		: RTNL: assertion failed at net/ipv6/addrconf.c (2164)/RTNL: assertion failed at net/ipv4/devinet.c (1055)
Submitter	: Krzysztof Oledzki <olel@ans.pl>
Date		: 2007-12-11 03:20
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9543
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Herbert Xu <herbert@gondor.apana.org.au>
		  Jay Vosburgh <fubar@us.ibm.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=9543#c6


Subject		: PATA_HPT37X embezzles two ports
Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
Date		: 2007-12-12 11:05
References	: http://lkml.org/lkml/2007/12/12/161
		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: http://lkml.org/lkml/2007/1/4/161


Subject		: Regression: Battery method parse error
Submitter	: Bruce Duncan <B.W.Duncan@sms.ed.ac.uk>
Date		: 2007-12-23 13:00
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9627
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14181&action=view


Subject		: restore ARMv6 OProfile support
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2007-12-28 11:39
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9653
		  http://lkml.org/lkml/2007/12/28/99
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Patch		: http://lkml.org/lkml/2007/12/29/111


Subject		: restore blackfin HARDWARE_PM support
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2007-12-28 11:40
References	: http://lkml.org/lkml/2007/12/28/100
		  http://bugzilla.kernel.org/show_bug.cgi?id=9654
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Patch		: http://lkml.org/lkml/2007/12/29/75


Subject		: max_cstate VMware regression
Submitter	: Mark Lord <lkml@rtr.ca>
Date		: 2008-01-03 14:54
References	: http://lkml.org/lkml/2008/1/2/328
		  http://bugzilla.kernel.org/show_bug.cgi?id=9683
Handled-By	: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2008/1/3/399


Subject		: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
Submitter	: Benjamin LaHaise <bcrl@kvack.org>
Date		: 2008-01-06 23:03
References	: http://lkml.org/lkml/2008/1/6/248
		  http://bugzilla.kernel.org/show_bug.cgi?id=9736
Handled-By	: "Eric W. Biederman" <ebiederm@xmission.com>
Patch		: http://lkml.org/lkml/2008/1/7/60


Subject		: [PATCH] Fix 2.6.24-rc7 regression in asix.c
Submitter	: Russ Dill <russ.dill@gmail.com>
Date		: 2008-01-08 15:17
References	: http://lkml.org/lkml/2008/1/8/435
		  http://bugzilla.kernel.org/show_bug.cgi?id=9739
Handled-By	: Russ Dill <russ.dill@gmail.com>
Patch		: http://lkml.org/lkml/2008/1/8/435


Subject		: pnpacpi : exceeded the max number of IO resources
Submitter	: Chris Holvenstot <cholvenstot@comcast.net>
Date		: 2007-11-30 07:14
References	: http://lkml.org/lkml/2007/11/30/110
		  http://bugzilla.kernel.org/show_bug.cgi?id=9740
Handled-By	: Rene Herman <rene.herman@keyaccess.nl>
Patch		: http://lkml.org/lkml/2008/1/9/168


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
