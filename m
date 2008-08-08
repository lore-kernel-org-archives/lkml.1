Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYHHMgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYHHMgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYHHMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:36:46 -0400
Received: from smtp.knology.net ([24.214.63.101]:51287 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbYHHMgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:36:46 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1218170004.2540.28.camel@jaswinder.satnam>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
	 <1218133288.18118.20.camel@lap75545.ornl.gov>
	 <1218166270.2540.9.camel@jaswinder.satnam>
	 <1218168646.17642.27.camel@obelisk.thedillows.org>
	 <1218170004.2540.28.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 08:36:42 -0400
Message-Id: <1218199002.17642.59.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 10:03 +0530, Jaswinder Singh wrote:
> On Fri, 2008-08-08 at 00:10 -0400, David Dillow wrote:
> 
> > I'll take a closer look when I'm awake, but there are some nitpicky
> > style issues remaining:
>
> Please give me your script I will try with your scripts.

I am afraid I can send you neither my eyes nor my gray matter. Loaning
the use of them is another matter, but you've had them at least
semi-engaged for some time now. :)

The things I'm pointing out may be nitpicky, yes, but they are things
you get from looking at the shape of the code and seeing ways that it
could be made simpler and more readable.

> > You don't need the 'goto out', a break will work fine. 
> 
> Earlier I was also using break. 
> For a safe side I used goto as If some one write more code it will not
> make any problem.

So the person who adds more code can change to a goto at that time --
meanwhile, the code will be more readable.

> > And you'll not be
> > pressed up against the right side of the screen if you just do  
> 
> Yes, I also think about this. But this is not an issue as it is < 80
> and every thing is coming in one line only.

Is the wrapping on the printk not just butt-ugly to you? If it can be
easily avoided by removing some indent, why wouldn't you want to?

These are small points, to be sure.

Dave



