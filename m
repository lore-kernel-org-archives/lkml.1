Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZCJLXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZCJLXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZCJLW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:22:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39472 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbZCJLW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:22:56 -0400
Date: Tue, 10 Mar 2009 12:22:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christopher Brannon <cmbrannon@cox.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-ID: <20090310112240.GC1337@ucw.cz>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Under Plan 9 from Bell Labs, one queries or sets the system clock by
> reading or writing text strings to a special file named /dev/time.
> I implemented such a facility for Linux.  A read of /dev/time produces
> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> jiffies since boot, and jiffies per second.  Writing a decimal
> number to

Jiffies are strange... and I guess time should be exported as 123.456
(seconds . fractional part). That way we are not limited to
nanoseconds...

Same interface can be used for setting precise time...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
