Return-Path: <linux-kernel-owner+w=401wt.eu-S2992820AbXDYQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992820AbXDYQRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992815AbXDYQRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:17:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33493 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992820AbXDYQRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:17:20 -0400
Date: Wed, 25 Apr 2007 18:16:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Reasons to merge suspend2.
Message-ID: <20070425161656.GA17253@elf.ucw.cz>
References: <200704251551.38373.a1426z@gawab.com> <alpine.DEB.0.98.0704251111000.18512@sigma.j-a-k-j.com> <Pine.LNX.4.64.0704251600030.25153@server.thyself>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704251600030.25153@server.thyself>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>I didn't read your whole post, it's way too long, but I would like to see
> >>your patch in mainline as an option to swsusp.  What would make this
> >>infeasible?
> >
> >For one thing, Linus said not but yesterday that he doesn't want multiple
> >competing suspend algorithms like this in the kernel at once. (If I parsed
> >his message correctly, he doesn't want any in the kernel, but he's putting
> >up with it because it seems somewhat needed.)
> 
> Would it be a feasible solution to have a very minimal and generic software 
> suspend in the kernel, and then various userspace implementations could 
> take care of this? 

Yes please. If you want suspend-over-nfs or whatever, just add it to
the userspace; we have enough support in kernel now.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
