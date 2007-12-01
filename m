Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXLAVyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXLAVyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 16:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXLAVyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 16:54:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35676 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbXLAVyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 16:54:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc3-git6: Reported regressions from 2.6.23
Date: Sat, 1 Dec 2007 23:12:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712012312.42136.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message contains a list of some regressions from 2.6.23 which have been
reported since 2.6.24-rc1 was released and for which there are no fixes in the
mainline that I know of.  If any of them have been fixed already, please let me
know.

If you know of any other unresolved regressions from 2.6.23, please let me know
either and I'll add them to the list.


Subject		: On 2.6.24-rc1-gc9927c2b BUG: unable to handle kernel paging request at virtual address 3d15b925
Submitter	: Giacomo Catenazzi <cate@cateee.net>
References	: http://lkml.org/lkml/2007/10/24/487
		  http://bugzilla.kernel.org/show_bug.cgi?id=9246
Handled-By	: 
Patch		: 


Subject		: EHCI causes system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
		  David Brownell <david-b@pacbell.net>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: 
Note:		: the problem appears to heavily depend on hardware


Subject		: leds: ledtrig-timer calls sleeping function from invalid context
Submitter	: Márton Németh <nm127@freemail.hu>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9264
Handled-By	: Richard Purdie <rpurdie@rpsys.net>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13493&action=view


Subject		: Device mapper regression 2.6.23 vs. v2.6.23-6597-gcfa76f0
Submitter	: Thomas Meyer <thomas@m3y3r.de>
References	: http://lkml.org/lkml/2007/10/21/153
		  http://bugzilla.kernel.org/show_bug.cgi?id=9280
Handled-By	: 
Patch		: 


Subject		: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Submitter	: Florin Iucha <florin@iucha.net>
References	: http://lkml.org/lkml/2007/10/28/65
		  http://bugzilla.kernel.org/show_bug.cgi?id=9291
Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>
		  Fengguang Wu <wfg@mail.ustc.edu.cn>
Patch		: http://lkml.org/lkml/2007/11/1/417


Subject		: PATA scan: ACPI Exception AE_AML_PACKAGE_LIMIT... is beyond end of object
Submitter	: Hans de Bruin <bruinjm@xs4all.nl>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9320
Handled-By	: Robert Moore <Robert.Moore@intel.com>
		  Tejun Heo <htejun@gmail.com>
		  Fu Michael <michael.fu@intel.com>
Patch		: 


Subject		: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
Submitter	: "Thomas Lindroth" <thomas.lindroth@gmail.com>
References	: http://lkml.org/lkml/2007/11/7/152
		  http://bugzilla.kernel.org/show_bug.cgi?id=9322
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Patch		: http://lkml.org/lkml/2007/11/11/115


Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
Submitter	: Roland Dreier <rdreier@cisco.com>
References	: http://lkml.org/lkml/2007/11/8/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
Handled-By	: 
Patch		: 


Subject		: system hangs after a few minutes
Submitter	: Marcus Better <marcus@better.se>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9335
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13762&action=view


Subject		: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
References	: http://lkml.org/lkml/2007/11/11/28
		  http://bugzilla.kernel.org/show_bug.cgi?id=9344
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
		  Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: 
Note		: Not reproducible with -rc3


Subject		: 2.6.24-rc2 STD with s2disk fails to activate suspended system after loading
Submitter	: Chris Friedhoff <chris@friedhoff.org>
References	: http://lkml.org/lkml/2007/11/10/114
		  http://bugzilla.kernel.org/show_bug.cgi?id=9345
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13651&action=view


Subject		: cd/dvd inaccessible in 2.6.24-rc2
Submitter	: Will Trives <will@trivescon.com.au>
References	: http://lkml.org/lkml/2007/11/9/290
		  http://bugzilla.kernel.org/show_bug.cgi?id=9346
Handled-By	: Len Brown <lenb@kernel.org>
		  Tejun Heo <htejun@gmail.com>
Patch		: 


Subject		: The keyboard doesn't work
Submitter	: Francois Valenduc <francois.valenduc@skynet.be>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9362
Handled-By	: Dmitry Torokhov <dtor@insightbb.com>
		  Ingo Molnar <mingo@elte.hu>
Patch		: 


Subject		: v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
Submitter	: Thomas Meyer <thomas@m3y3r.de>
References	: http://lkml.org/lkml/2007/11/13/250
		  http://bugzilla.kernel.org/show_bug.cgi?id=9370
Handled-By	: Matthew Wilcox <matthew@wil.cx>
Patch		: 


Subject		: SError: { DevExch } occuring and causing disruption
Submitter	: Avuton Olrich <avuton@gmail.com>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9393
Handled-By	: Tejun Heo <htejun@gmail.com>
		  Mark Lord <mlord@pobox.com>
Patch		: 


Subject		: nfsd gets stuck when underlying filesystem is XFS
Submitter	: Christian Kujau <lists@nerdbynature.de>
		  Chris Wedgwood <cw@f00f.org>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9400
Handled-By	: "J. Bruce Fields" <bfields@fieldses.org>
		  Christoph Hellwig <hch@infradead.org>
Patch		: http://lkml.org/lkml/2007/11/25/39


Subject		: 2.6.24-rc3: find complains about /proc/net
Submitter	: Pavel Machek <pavel@ucw.cz>
References	: http://lkml.org/lkml/2007/11/19/253
		  http://bugzilla.kernel.org/show_bug.cgi?id=9411
Handled-By	: "Eric W. Biederman" <ebiederm@xmission.com>
Patch		: http://lkml.org/lkml/2007/11/26/259


Subject		: Not work light of button-led with module b43 in chipset broadcom 4318
Submitter	: Cristian Aravena Romero <caravena@gmail.com>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9414
Handled-By	: 
Patch		: 


Subject		: unable to turn cooling device 'off' - LG LE50 Express laptop
Submitter	: Marcus Better <marcus@better.se>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9432
Handled-By	: Len Brown <lenb@kernel.org>
Patch		: 


Subject		: 2.6.24-rc3 can't see sd partitions on Alpha
Submitter	: Bob Tracy <rct@gherkin.frus.com>
References	: http://lkml.org/lkml/2007/11/18/3
		  http://bugzilla.kernel.org/show_bug.cgi?id=9457
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
Patch		: 


Subject		: ACPI related Warning in 2.6.24-rc3-git2
Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
		  Jens Axboe <jens.axboe@oracle.com>
References	: http://lkml.org/lkml/2007/11/27/156
		  http://lkml.org/lkml/2007/11/28/130
		  http://lkml.org/lkml/2007/11/27/228
		  http://bugzilla.kernel.org/show_bug.cgi?id=9469
Handled-By	: Zhao Yakui <yakui.zhao@intel.com>
Patch		: http://lkml.org/lkml/2007/11/29/43


Subject		: Oops with 2.6.24 git when loading iwl3945
Submitter	: "Thomas Tuttle" <linux-kernel@ttuttle.net>
References	: http://lkml.org/lkml/2007/11/27/255
		  http://bugzilla.kernel.org/show_bug.cgi?id=9470
Handled-By	: 
Patch		: 


Subject		: [build bug] SCTP, net/sctp/auth.c, ./net/rxrpc/ar-key.c fails to build
Submitter	: Ingo Molnar <mingo@elte.hu>
References	: http://lkml.org/lkml/2007/11/28/107
		  http://bugzilla.kernel.org/show_bug.cgi?id=9471
Handled-By	: Vlad Yasevich <vladislav.yasevich@hp.com>
Patch		: http://lkml.org/lkml/2007/11/28/158


Subject		: 2.6.24-rc3-git2 softlockup detected
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References	: http://lkml.org/lkml/2007/11/28/16
		  http://bugzilla.kernel.org/show_bug.cgi?id=9472
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
Patch		: 


Subject		: [parisc] 2.6.24-rc3 (64-bit, smp) fails to boot on 9000/785/J5600
Submitter	: Frans Pop <elendil@planet.nl>
References	: http://lkml.org/lkml/2007/11/27/72
		  http://bugzilla.kernel.org/show_bug.cgi?id=9473
Handled-By	: Kyle McMartin <kyle@mcmartin.ca>
Patch		: http://git.kernel.org/?p=linux/kernel/git/kyle/parisc-2.6.git;a=commit;h=f882ea80f4ef4b71ad5d788c10a714ff4fb62d35


Subject		: jiffies counter leaps in 2.6.24-rc3
Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
References	: http://lkml.org/lkml/2007/11/24/53
		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  Dave Jones <davej@redhat.com>
Patch		: 


Subject		: kernel GPF in 2.6.24 (g09f345da)
Submitter	: Jon Nelson <jnelson-kernel-bugzilla@jamponi.net>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9482
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
Patch		: 


Subject		: circular locking dependency detected
Submitter	: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
References	: http://lkml.org/lkml/2007/11/30/22
		  http://bugzilla.kernel.org/show_bug.cgi?id=9483
Handled-By	: 
Patch		: 


Subject		: Freezer: JFFS2 garbage collector freezing issue
Submitter	: "Rafael J. Wysocki" <rjw@sisk.pl>
References	: http://lkml.org/lkml/2007/12/1/94
		  http://bugzilla.kernel.org/show_bug.cgi?id=9484
Handled-By	: 
Patch		: http://lkml.org/lkml/2007/12/1/94


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Thanks,
Rafael
