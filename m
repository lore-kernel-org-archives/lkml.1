Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbXIEHYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbXIEHYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbXIEHYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:24:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47990 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbXIEHY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:24:29 -0400
Date: Wed, 5 Sep 2007 09:25:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, arekm@maven.pl
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: slow resume (was Re: [4/4] 2.6.23-rc5: known regressions)
Message-ID: <20070905072508.GC2017@elf.ucw.cz>
References: <46DBD982.3080102@googlemail.com> <46DBDDB5.7080307@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DBDDB5.7080307@googlemail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Subject         : resume from ram much slower
> References      : http://lkml.org/lkml/2007/8/10/275
> Last known good : 2.6.23-rc1 ?
> Submitter       : Arkadiusz Miskiewicz <arekm@maven.pl>
> Caused-By       : ?
> Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> Status          : problem is being debugged

Any progress here?

I see you have a thinkpad, so with right console loglevel, you should
be able to see the messages just after boot...? Where does it really
hang

                              [    0.955389] Back to C!
                              [    0.389803] PM: Writing back config
space on device 0000:00:01.0 at =                              offset
1 (was 100107, writing 100507)
                              [    0.389814] PCI: Setting latency
timer of device 0000:00:01.0 to 64

Is it here?

                              [  120.599158] PM: Writing back config
space on device 0000:00:1b.0 at =                              offset
1 (was 100006, writing 100002)
                              [  120.599185] ACPI: PCI Interrupt
0000:00:1b.0[A] -> GSI 16 (level, lo=                              w)
-> IRQ 16
 

Are you using nohz/highres?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
