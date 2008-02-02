Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbYBBT7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbYBBT7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYBBT7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:59:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55443 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754599AbYBBT7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:59:39 -0500
Date: Sat, 2 Feb 2008 20:59:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080202195956.GC31621@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <200802020931.38689.david-b@pacbell.net> <20080202180002.GB26560@elte.hu> <200802021113.22130.david-b@pacbell.net> <20080202193202.GB31621@elf.ucw.cz> <20080202193843.GB32039@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202193843.GB32039@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-02-02 20:38:43, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > It would have been easier to just use the public interface and 
> > > hard-wire "rtc0".  But going directly to the hardware was dirtier, 
> > > and more in the spirit of "hack that obviously shouldn't go upstream 
> > > until it gets done properly".
> > 
> > Yes, it was "quick and dirty". And I do not think it is going upstream 
> > in this form...?
> 
> which would be a pity - this thing _almost_ started doing suspend and 
> resume cycles on my testsystems, all by itself :-)

...which is good reason for me to create cleaned-up patch, right?

wakeup in .c now works, so I actually have time to do it now.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
