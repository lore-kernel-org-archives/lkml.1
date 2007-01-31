Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbXAaKfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbXAaKfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932960AbXAaKfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:35:08 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49170 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932957AbXAaKfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:35:05 -0500
Date: Wed, 31 Jan 2007 11:34:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@osdl.org>, David Brownell <david-b@pacbell.net>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-ID: <20070131103448.GB19640@elf.ucw.cz>
References: <20061219185223.GA13256@srcf.ucam.org> <200701261356.42171.david-b@pacbell.net> <20070126231521.GA12370@srcf.ucam.org> <200701261642.56896.david-b@pacbell.net> <20070126165657.663358ab.akpm@osdl.org> <20070127173804.GD3942@ucw.cz> <20070127224206.GA26241@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127224206.GA26241@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Change breaking that was 'introduce suspend early to fix suspend on
> > mac mini', by Linus, IIRC. So no, it is not easy to revert this one.
> 
> But it's easy to fix it. Either drivers need suspend routines that

Yes, that's right. It is easy to fix, but not as easy as "just revert".

> called without interrupts enabled, or they don't. The current situation 
> is that the interface is broken regardless of which is the case - the 
> situation with the patch is that the interface only stops working for 
> drivers that need the suspend routine to be called with disabled 
> interrupts. 

...unfortunately that patch was pretty ugly, and it still does not
solve the "will it oops when I try to use it" part of problem.

(Thanks for your ipw2100 runtime pm work, btw).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
