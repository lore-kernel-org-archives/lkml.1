Return-Path: <linux-kernel-owner+w=401wt.eu-S934770AbXHGPPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770AbXHGPPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXHGPPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:15:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23835 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbXHGPPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:15:35 -0400
Subject: Re: Old -rt patches
From: Daniel Walker <dwalker@mvista.com>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <46B82CDD.7020503@free.fr>
References: <46B0B7A4.8060805@free.fr>  <46B6E210.9090502@free.fr>
	 <1186466508.22044.8.camel@imap.mvista.com>  <46B82CDD.7020503@free.fr>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 08:10:52 -0700
Message-Id: <1186499452.22044.32.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 10:27 +0200, John Sigler wrote:
> Daniel Walker wrote:
> 
> > John Sigler wrote:
> > 
> >> Would anyone care to comment?
> > 
> > I'm not sure if this is the answer that you're looking for, but yes you
> > certainly will find fixed bug is older version of the tree.
> 
> I am not a kernel hacker, therefore I can only imagine how complex it is 
> to bring real-time to Linux. For some reason, I had come to believe that 
> the case of a single CPU without dynticks had been "solved" in the more 
> recent kernels (say 2.6.20), and that development had moved on, and was 
> now active in more "complex" areas like SMP/multi-core, dynticks, etc.

There is always a chance of something not working, or a regression
getting introduced in any of the code .. -rt is all still a development
tree too, so it may not always be stable.

> >> Perhaps I could also test a different strategy, such as xenomai?
> >> http://www.xenomai.org/
> > 
> > If it's a kernel bug it's not going to matter if you use a xenomai skin
> > or not.. If you use some other real time layer that might fix it ..
> 
> *If* it is a bug in the -rt patch, then Adeos/Xenomai coupled with a 
> vanilla Linux kernel should not be affected by the same bug. Unless my 
> logic is broken somewhere.

I wouldn't think so, but then what if Adeos/Xenomai has a new bug?

> > you really need to test your app on a current version of the kernel ..
> > We as developers generally don't support out dated trees..
> 
> This is the part I don't understand. I work for a tiny company with 
> limited resources. It's infeasible for me to track every new kernel 
> release and upgrade every time. I need to pick a kernel version that has 
> the functionality we need, test it thoroughly with my app, and then 
> never touch that kernel again.

Ok ..

> Unless I am mistaken, some people (like Thomas) have been deploying 
> systems based on PREEMPT_RT (or just -hrt) in indutrial settings for a 
> long time. (As far back as 2.6.15?) Obviously many bugs have been fixed 
> since then, which means that these versions contained many bugs.

It's not a stretch to imagine. These real time chance has already been
included in commercial distros, and are generally getting made into
various products right now .. Just like what your doing .

> How does one react when an important bug in found in a system that is 
> already in the field? Do they provide a way to upgrade the kernel (like 
> consumer-grade network routers)? Do they replace the complete system?

I don't really know the details of this , but I would imagine there is
some sort of upgrade path for say routers .. I've heard people talk
about cell phone upgrading their software over the air.. It would be a
difficult proposition to say make some specific kernel static forever ..
Even the mainline stable kernel has bugs that get fixed..

Daniel

