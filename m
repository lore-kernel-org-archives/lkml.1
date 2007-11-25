Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbXKYVMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbXKYVMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 16:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbXKYVMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 16:12:16 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37205 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752905AbXKYVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 16:12:16 -0500
Date: Sun, 25 Nov 2007 22:12:03 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [RFC][PATCH] Update REPORTING-BUGS
Message-ID: <20071125211203.GB18284@stusta.de>
References: <200711252157.10212.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711252157.10212.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 09:57:09PM +0100, Rafael J. Wysocki wrote:
>...
> +Reporting Linux kernel bugs
>...
> +Usually, this requires you to do some more work than just sending an email
> +message with a bug report, but it often is necessary to collect all information
> +related to the reported bug in one place, so that it is easily accessible at
> +any time later.

I wouldn't say creating an account (if you don't already have one)
plus 5 additional mouse clicks per bug report are substancially more 
work.

> +Email messages containing bug reports should generally be sent to the
> +Linux Kernel Mailing List (LKML) <linux-kernel@vger.kernel.org> and to the
> +mailing list dedicated to the affected subsystem.

How should a newbie find the correct mailing list?

Benchmark:
Easier than the "some more work" when using Bugzilla.

>...
> +It also is a good idea to notify the maintainer of the affected subsystem and
> +the maintainer of the tree in which the bug is present by adding their email
> +addresses to the Cc list of the bug report message.  The email addresses of
> +maintainers of the majority of kernel subsystems can be found in the MAINTAINERS
> +file, but you should not worry too much about getting a wrong person.

If you don't already know MAINTAINERS well then finding the right 
component in Bugzilla is much easier.

> +If you know which patch has caused the problem to appear, you should also add
> +the email address of its author to the Cc list of your bug report (this address
> +is usually present in the 'From:' field of the patch header).  Additionally,
> +it is recommended to notify all of the people involved in the process of
> +merging the patch (you can find their addresses in the 'Signed-off-by:' and
> +'Acked-by:' or 'Reviewed-by:' fields of the patch header).  This way you can
> +increase the probability that someone "in the know" will notice the report and
> +respond to it quickly.  Apart from this, you should make it clear that your
> +message contains a bug report, for example by adding the word "BUG" in front
> +of the message's subject line.  If the bug is a regression (ie. one of the
> +previous kernel versions worked correctly), please put the word "REGRESSION" in
> +there instead.
> +
> +Unfortunately, sometimes bug reports are not responded to even if they contain
> +all of the right email addresses etc.  If that happens to your bug report, you
> +should first check if it has not been intercepted by a spam filter.  This is
> +easy if you have sent the report to a mailing list, since in that case it only
> +is necessary to look into the list's archives to see if the message is there.
> +If it turns out that the report has reached the list and no one is responding to
> +it, the developers might have overlooked it or they may be too busy to take care
> +of it right now.  In that case you should wait for some time (usually, a couple
> +of days) and send it once again (if you resend the report, you may add the word
> +"resend" to the message's subject to indicate that this is not the first time).
> +If that does not help and there still is no response, it is best to open a new
> +entry in the Bugzilla at http://bugzilla.kernel.org .  If you have already done
> +that, send messages to the appropriate lists and people periodically to remind
> +of the issue.

What about recommending a cronjob that resends the bug report every 
three days?   ;-)

Really, we must define _one_ way for people to report a bug, and how 
developers are reminded is _our_ job.

>...
> +Generally, the following things are appreciated in a bug report:
>...

If you expect people to read and follow this, wouldn't it be easier to
simply point them to open the bug in Bugzilla where we already have a
template asking these questions?


You could replace the whole contents of this file with:
Go to http://bugzilla.kernel.org/ and click on "Enter a new bug report".

It's a pity that we manage to add/change an average of 100.000 bugs^Wlines
of code each month, but do not have one generally accepted and working 
process for bug reports.

>  Thank you
> +

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

