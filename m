Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbXKYR0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbXKYR0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 12:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXKYR00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 12:26:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3588 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753385AbXKYR0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:26:25 -0500
Date: Wed, 21 Nov 2007 17:26:47 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: rjw@sisk.pl, linux-main <linux-kernel@vger.kernel.org>
Subject: Re: Suspend/Resume/Hibernation - bisecting or bug-logs?
Message-ID: <20071121172646.GA3888@ucw.cz>
References: <20071116161420.e2c57ff6.Kristoffer.Ericson@Gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116161420.e2c57ff6.Kristoffer.Ericson@Gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-11-16 16:14:20, Kristoffer Ericson wrote:
> Greetings,
> 
> Ive been following your discussion and documentation efforts concerning pm in the kernel. This has in the past been a gray area which was hard to find information about so kudos.
> 
> I maintain 2 handheld platforms that would benefit greatly from implementing proper pm (mainly suspend) but Im having problems bugtracking it. Currently the system tries to suspend but fails somewhere and then tries to resume (which fails). The end result however is that Im unable to see anything (bugmessages...) since the video driver gets deactivated by pm.
> 
> My question is this: Is bisecting (turning off device support in kernel until it works) the best approach when bugtracking pm suspend? Or is there any other logging system that I can use?

Bisecting is not bad. Or you can port store-progress-into-rtc hacks
from pc...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
