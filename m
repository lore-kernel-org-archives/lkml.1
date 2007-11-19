Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbXKSV5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbXKSV5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXKSV5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:57:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40117 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXKSV5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:57:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc3-git1: Reported regressions from 2.6.23
Date: Mon, 19 Nov 2007 23:15:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711192315.05767.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
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


Subject		: Commit "Hibernation: Enter platform hibernation state in a consistent way)" makes my system to resume instantly from S4
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
References	: http://lkml.org/lkml/2007/10/27/66
		  http://bugzilla.kernel.org/show_bug.cgi?id=9258
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
Patch		: 
Note		: $subject commit apparently exposes a problem that existed previously
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


Subject		: 100% iowait on one of cpus in current -git
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
		  Thomas Schwarzgruber <possebaer@gmx.at>
References	: http://lkml.org/lkml/2007/10/22/20
		  http://lkml.org/lkml/2007/10/31/212
		  http://bugzilla.kernel.org/show_bug.cgi?id=9289
Handled-By	: Fengguang Wu <wfg@mail.ustc.edu.cn>
Patch		: 


Subject		: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Submitter	: Florin Iucha <florin@iucha.net>
References	: http://lkml.org/lkml/2007/10/28/65
		  http://bugzilla.kernel.org/show_bug.cgi?id=9291
Handled-By	: Trond Myklebust <trond.myklebust@fys.uio.no>
		  Fengguang Wu <wfg@mail.ustc.edu.cn>
Patch		: 


Subject		: 2.6.24-rc1-g74521c28: oops during boot [<ffffffff881c03e4>] :power_supply:power_supply_show_property+0x94/0x150
Submitter	: Thomas Bächler <thomas@archlinux.org>
References	: http://lkml.org/lkml/2007/11/3/35
		  http://bugzilla.kernel.org/show_bug.cgi?id=9299
Handled-By	:
Patch		: http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commitdiff_plain;h=4c41d3ad6544f1c9aec37c441af04f5d0ad3a731


Subject		: Audigy 2 ZS Notebook prevents snd_emu10k1 module from loading/working
Submitter	: unggnu@googlemail.com
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9304
Handled-By	: Takashi Iwai <tiwai@suse.de>
		  James Courtier-Dutton <James@superbug.demon.co.uk>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=13511&action=view


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


Subject		: system hangs with blank screen after some time
Submitter	: Marcus Better <marcus@better.se>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9335
Handled-By	: Andrew Morton <akpm@linux-foundation.org>
Patch		: 


Subject		: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
References	: http://lkml.org/lkml/2007/11/11/28
		  http://bugzilla.kernel.org/show_bug.cgi?id=9344
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
Patch		: 


Subject		: 2.6.24-rc2 STD with s2disk fails to activate suspended system after loading
Submitter	: Chris Friedhoff <chris@friedhoff.org>
References	: http://lkml.org/lkml/2007/11/10/114
		  http://bugzilla.kernel.org/show_bug.cgi?id=9345
Handled-By	: 
Patch		: 


Subject		: cd/dvd inaccessible in 2.6.24-rc2
Submitter	: Will Trives <will@trivescon.com.au>
References	: http://lkml.org/lkml/2007/11/9/290
		  http://bugzilla.kernel.org/show_bug.cgi?id=9346
Handled-By	:
Patch		: 


Subject		: 2.6.24-rc1-gb4f5550 oops
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
References	: http://lkml.org/lkml/2007/11/5/6
		  http://bugzilla.kernel.org/show_bug.cgi?id=9352
Handled-By	: "Rafael J. Wysocki" <rjw@sisk.pl>
		  Peter Zijlstra <peterz@infradead.org>
Patch		: 


Subject		: kernel hangs at boot while running udev
Submitter	: Dino Leonardo Sangoi <dino@trieste.linux.it>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9355
Handled-By	: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
		  Len Brown <len.brown@intel.com>
Patch		: 


Subject		: The keyboard doesn't work
Submitter	: Francois Valenduc <francois.valenduc@skynet.be>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9362
Handled-By	: 
Patch		: 


Subject		: v2.6.24-rc2-409-g9418d5d: attempt to access beyond end of device
Submitter	: Thomas Meyer <thomas@m3y3r.de>
References	: http://lkml.org/lkml/2007/11/13/250
		  http://bugzilla.kernel.org/show_bug.cgi?id=9370
Handled-By	: Matthew Wilcox <matthew@wil.cx>
Patch		: 


Subject		: Reproducable hang with 2.6.24-rc2 using oprofile
Submitter	: Jan Kara <jack@suse.cz>
References	: http://lkml.org/lkml/2007/11/13/225
		  http://bugzilla.kernel.org/show_bug.cgi?id=9371
Handled-By	: 
Patch		: 


Subject		: [ICH7 snd_hda_intel] Volume control broken
Submitter	: Frans Pop <elendil@planet.nl>
References	: http://bugzilla.kernel.org/show_bug.cgi?id=9374
Handled-By	: Takashi Iwai <tiwai@suse.de>
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
Patch		: 


Subject		: Regression in 2.6.24-rc3 - 64-bit DMA fails for BCM94311MCG rev 02
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
References	: http://lkml.org/lkml/2007/11/18/123
		  http://bugzilla.kernel.org/show_bug.cgi?id=9408
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: 


Subject		: regression from softlockup fix
Submitter	: David Miller <davem@davemloft.net>
References	: http://lkml.org/lkml/2007/11/19/38
		  http://bugzilla.kernel.org/show_bug.cgi?id=9409
Handled-By	: Ingo Molnar <mingo@elte.hu>
Patch		: http://lkml.org/lkml/2007/11/19/46


Subject		: 2.6.24-rc3: find complains about /proc/net
Submitter	: Pavel Machek <pavel@ucw.cz>
References	: http://lkml.org/lkml/2007/11/19/253
		  http://bugzilla.kernel.org/show_bug.cgi?id=9411
Handled-By	: 
Patch		: 


For details, please follow the links given in references.

As you can see, there is a Bugzilla entry for each of the listed regressions.
There also is a Bugzilla entry used for tracking the regressions from 2.6.23,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=9243

Please let me know if there are any Bugzilla entries that should be added to
the list in there.

Greetings,
Rafael

