Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbYBBTbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbYBBTbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYBBTbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:31:43 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35878 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752257AbYBBTbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:31:42 -0500
Date: Sat, 2 Feb 2008 20:32:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080202193202.GB31621@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <200802020931.38689.david-b@pacbell.net> <20080202180002.GB26560@elte.hu> <200802021113.22130.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802021113.22130.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-02-02 11:13:21, David Brownell wrote:
> On Saturday 02 February 2008, Ingo Molnar wrote:
> >
> > > > Yep, you are right, but that is the easy issue to fix.
> > > 
> > > Which is why I was puzzled that you didn't start out doing it the 
> > > "right" way ... even just hard-wiring the dubious assumption that 
> > > "rtc0" is the right RTC to use.  :)
> > 
> > because this was mostly about an quick & easy hack to see whether it 
> > makes sense at all to automate the testing of suspend/resume.
> 
> I think you should have written "quick and dirty".  ;)
> 
> It would have been easier to just use the public interface
> and hard-wire "rtc0".  But going directly to the hardware
> was dirtier, and more in the spirit of "hack that obviously
> shouldn't go upstream until it gets done properly".

Yes, it was "quick and dirty". And I do not think it is going
upstream in this form...?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
