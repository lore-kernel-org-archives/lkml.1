Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbXEEVPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbXEEVPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXEEVPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:15:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60199 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754047AbXEEVPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:15:50 -0400
Date: Sat, 5 May 2007 12:08:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-pm@lists.osdl.org
Subject: Re: [patch] suspend/resume debugging: device filter
Message-ID: <20070505100855.GC25704@elf.ucw.cz>
References: <20070125110501.GA25151@elte.hu> <20070126015536.GA14917@suse.de> <20070505092425.GA23125@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505092425.GA23125@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Here's a (compile tested only) patch that does this on a per-device 
> > basis, which is smaller, and should work just as well as your patch.
> > 
> > It creates a new file in the power/ directory for every device called 
> > "can_suspend".  Write a '0' to it to prevent that device from being 
> > suspended.
> > 
> > Does this work for you?
> 
> yeah, i was able to use this too to debug suspend/resume problems. But 
> i've added the check to the resume path too - for example sw-suspend 
> does a resume of devices during its suspend cycle, cutting off much of 
> the netconsole output.
> 
> which makes the can_suspend flag mis-named - perhaps rename it to 
> exclude_pm ?

debug_exclude_pm? I do not want people playing with it, then
complaining that they broke the suspend.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
