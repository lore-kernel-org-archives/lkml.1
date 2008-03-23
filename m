Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYCWVR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYCWVR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 17:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYCWVRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 17:17:48 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:49901 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbYCWVRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 17:17:46 -0400
Date: Sun, 23 Mar 2008 22:17:38 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <200803170018.52663.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.00.0803232004300.13579@sheep.housecafe.de>
References: <200803170018.52663.rjw@sisk.pl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9983
> Subject		: PROBLEM: 2.6.25-rc1-git2 freezes when accessing external USB hard disk (ehci-hcd)
> Submitter	: Linas Žvirblis <0x0007@gmail.com>
> Date		: 2008-02-13 22:38 (33 days old)
> References	: http://lkml.org/lkml/2008/2/13/566

Linas did not respond any more, and you closed the bug :)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10051
> Subject		: Spurious messages at boot, eventually hangs the usb subsustem
> Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> Date		: 2008-02-20 09:10 (26 days old)

Hm, Jean-Luc said:
>  ------- Comment  #4 From Jean-Luc Coulon  2008-03-09 22:50:19   ----
>  BTW, I can normally boot my system since rc4

Close?

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10086
> Subject		: 2.6.25-rc2 + smartd = hang
> Submitter	: Anders Eriksson <aeriksson@fastmail.fm>
> Date		: 2008-02-22 17:51 (24 days old)
> References	: http://lkml.org/lkml/2008/2/22/239
> Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

http://bugzilla.kernel.org/show_bug.cgi?id=10086#c5 says it's fixed.


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10133
> Subject		: INFO: possible circular locking in the resume
> Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Date		: 2008-02-27 (19 days old)
> References	: http://lkml.org/lkml/2008/2/26/479
> Handled-By	: Gautham R Shenoy <ego@in.ibm.com>

Gautham said on 2008-02-28 he has a patch - but did not post it. What now?


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10146
> Subject		: 2.6.25-rc: complete lockup on boot/start of X (bisected)
> Submitter	: Marcin Slusarz <marcin.slusarz@gmail.com>
> Date		: 2008-03-02 20:00 (15 days old)
> References	: http://lkml.org/lkml/2008/3/2/91
> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>

Seems to be fixed: http://lkml.org/lkml/2008/3/23/275

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10152
> Subject		: Clocksource tsc is always unstable with 2.6.25-* kernels and CONFIG_NO_HZ=y on my box
> Submitter	: Gabriel C <nix.or.die@googlemail.com>
> Date		: 2008-02-24 01:31 (22 days old)
> References	: http://lkml.org/lkml/2008/2/23/380
> 		  http://lkml.org/lkml/2008/2/24/281
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>

Seems to be fixed by: http://lkml.org/lkml/2008/3/22/66
Which introduced a WARNNG:, fixed by the subsequent: 
http://lkml.org/lkml/2008/3/23/199

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10190
> Subject		: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
> Submitter	: Tarkan Erimer <tarkan@netone.net.tr>
> Date		: 2008-03-05 05:01 (12 days old)
> References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0803.0/1867.html

Bugzila entry is closed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10211
> Subject		: drivers/media/video/cx2341x.c: undefined references
> Submitter	: Toralf Förster <toralf.foerster@gmx.de>
> Date		: 2008-03-07 13:48 (10 days old)
> References	: http://lkml.org/lkml/2008/3/7/168

Closed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10234
> Subject		: pciehp hang on hp ia64 rx6600
> Submitter	: Alex Chiang <achiang@hp.com>
> Date		: 2008-03-12 00:47 (5 days old)
> References	: http://lkml.org/lkml/2008/3/12/31
> Handled-By	: Mark Lord <mlord@pobox.com>

Closed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10238
> Subject		: netconsole still hangs
> Submitter	: Andrew Morton <akpm@linux-foundation.org>
> Date		: 2008-03-12 23:14 (5 days old)
> References	: http://marc.info/?t=120536379200004&amp;r=1&amp;w=2
> Handled-By	: David Miller <davem@davemloft.net>
> 		  Stephen Hemminger <shemminger@linux-foundation.org>

Closed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10242
> Subject		: rm command hangs
> Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> Date		: 2008-03-14 05:47 (3 days old)

Maybe related to http://bugzilla.kernel.org/show_bug.cgi?id=10207, which 
is (about to be) closed?

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10266
> Subject		: [PATCH] i810fb: Fix console switch regression
> Submitter	: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
> Date		: 2008-03-16 19:42 (1 days old)
> References	: http://lkml.org/lkml/2008/3/16/84

Closed.

> Regressionn with patches
> ------------------------
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10016
> Subject		: cobalt_btns.c &lt;-&gt; struct platform_device compile error
> Submitter	: Adrian Bunk <bunk@kernel.org>
> Date		: 2008-02-17 12:12 (29 days old)
> References	: http://lkml.org/lkml/2008/2/17/293
> Handled-By	: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> Patch		: http://lkml.org/lkml/2008/3/9/25

Closed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10017
> Subject		: cdev removal broke cobalt_btns.c compilation
> Submitter	: Adrian Bunk <bunk@kernel.org>
> Date		: 2008-02-17 12:14 (29 days old)
> References	: http://lkml.org/lkml/2008/2/17/295
> Handled-By	: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> Patch		: http://lkml.org/lkml/2008/3/9/25

Closed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10186
> Subject		: SCSI_AIC94XX must depend on SCSI
> Submitter	: Toralf Förster <toralf.foerster@gmx.de>
> Date		: 2008-03-06 19:09 (11 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=120483073617232&amp;w=2
> Handled-By	: Adrian Bunk <bunk@kernel.org>
> Patch		: http://marc.info/?l=linux-kernel&amp;m=120483499725928&amp;w=2

Testing...

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10210
> Subject		: 2.6.25-rc4-git3: Handling of audio CDs broken on pata_ali
> Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> Date		: 2008-03-08 22:46 (9 days old)
> References	: http://lkml.org/lkml/2008/3/8/123
> Handled-By	: Tejun Heo <htejun@gmail.com>
> Patch		: http://lkml.org/lkml/2008/3/10/69

Closed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10232
> Subject		: intel mtrr fixups apparently broke display and e1000 probe
> Submitter	: Stephen Gran <steve@lobefin.net>
> Date		: 2008-03-12 08:37 (5 days old)
> Handled-By	: Yinghai Lu <yhlu.kenrel@gmail.com>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15271&amp;action=view

Closed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10259
> Subject		: /sys/class/hwmon/hwmon0 is missing a device link
> Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> Date		: 2008-03-16 04:56 (1 days old)
> Handled-By	: Jean Delvare <khali@linux-fr.org>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15301&amp;action=view

Closed.


Thanks,
Christian.
-- 
BOFH excuse #387:

Your computer's union contract is set to expire at midnight.
