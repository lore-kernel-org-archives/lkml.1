Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYJBIhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYJBIhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYJBIhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:37:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60551 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbYJBIhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:37:03 -0400
Date: Thu, 2 Oct 2008 10:37:00 +0200
From: Pavel Machek <pavel@suse.cz>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       rpurdie@rpsys.net, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
Message-ID: <20081002083700.GB19993@atrey.karlin.mff.cuni.cz>
References: <20080919143744.009764000@polaris-admin.engr.sgi.com> <20080919143744.190005000@polaris-admin.engr.sgi.com> <20080922114820.GA13990@elte.hu> <48D7AEE6.7080804@sgi.com> <20080928194201.GA1310@ucw.cz> <48E3BE2D.4020606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E3BE2D.4020606@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pavel Machek wrote:
> >> Another relevant point is that I will be adding a bit more functionality
> >> to disable the timer interrupt on truly "idle" cpus (like have been idle
> >> for some amount of seconds).  We would then use the "exit from idle"
> >> callback to reestablish the timer interrupt.  [This would allow them to
> >> enter power down states if appropriate.]
> > 
> > Should you look at nohz instead of reinventing it? 
> 
> Thanks, I did look at it.  Quite complex.  Maybe I'm missing something
> but I don't see how it fits in?  Are you saying I should be using

I seen your remark above about disabling timer interrupt on idle
cpus. That's exactly nohz functionality, right? Maybe I misunderstood
you and you meant "my monitoring interrupt" and not "generic system
timer interrupt"?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
