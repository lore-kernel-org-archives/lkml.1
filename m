Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbXHFOmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbXHFOmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763531AbXHFOmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:42:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44891 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbXHFOmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:42:02 -0400
Date: Mon, 6 Aug 2007 07:41:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: Old -rt patches
Message-ID: <20070806144158.GA9309@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <46B0B7A4.8060805@free.fr> <46B6E210.9090502@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B6E210.9090502@free.fr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 10:55:44AM +0200, John Sigler wrote:
> John Sigler wrote:
> 
> >I wrote a Linux app where I need high-resolution timers. I went all the 
> >way and installed the -rt patch, which includes the -hrt patches, as far 
> >as I understand.
> >
> >Since I could not afford to change kernels with every new release, I 
> >decided to track the 2.6.20 branch (arbitrarily).
> >
> >At this point I'm using 2.6.20.7-rt8 (-rt8 was the last patch to the 
> >2.6.20 branch). (I see 2.6.20 is already up to .15)
> >
> >I see a lot of patches going into the -rt patch, but development moved 
> >on to 2.6.21, then 2.6.22, and now 2.6.23, following mainline.
> >
> >I'm not a kernel hacker, so I don't claim to understand the patches, but 
> >the comments sound like a few bugs are fixed here and there. I can't 
> >tell whether these bugs also exist in previous kernels or only appeared 
> >in newer kernels. Even if I knew, I probably wouldn't have the expertise 
> >to back-port the patch.
> >
> >I'm seeing weird behavior in my app, when it has been running 2-4 days. 
> >The timers start to act out, and all hell breaks loose. Basically, I 
> >have no idea what's going on...
> >
> >My question is: is it possible that there is a bug in 2.6.20-rt8 that 
> >has been fixed in subsequent -rt patches (there's a 2.6.21.6-rt21 and a 
> >2.6.22.1-rt9)? In other words, if I give 2.6.21.6-rt8 or 2.6.22.1-rt9 a 
> >spin, is it possible that my weird behavior disappears?
> >
> >I'm not saying that it's impossible for the bug to be in my app, but the 
> >app is small enough that I'm fairly confident there's no problem there.
> 
> Would anyone care to comment?

Would you be willing to post your app so people could try to reproduce
your bug?

							Thanx, Paul

> Perhaps I could also test a different strategy, such as xenomai?
> http://www.xenomai.org/
> 
> Regards.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
