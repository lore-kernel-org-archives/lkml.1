Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbXJAI3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbXJAI3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXJAI3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:29:17 -0400
Received: from ip213-185-39-113.static.cust.eunet.fi ([213.185.39.113]:55043
	"EHLO dag.newtech.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752140AbXJAI3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:29:16 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Dag Nygren <dag@newtech.fi>, linux-kernel@vger.kernel.org, dag@newtech.fi
Subject: Re: 2.6.22.3 out of memory crash 
In-Reply-To: Message from Nick Piggin <nickpiggin@yahoo.com.au> 
   of "Fri, 28 Sep 2007 07:40:18 +1000." <200709280740.18641.nickpiggin@yahoo.com.au> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 01 Oct 2007 11:29:14 +0300
From: Dag Nygren <dag@newtech.fi>
Message-Id: <20071001082914.9A99B1160B@dag.newtech.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thursday 20 September 2007 16:56, Dag Nygren wrote:
> > Hi,
> >
> > I have the kview zoom function mapped to the scrollwheel
> > with ctrl.
> > Now my wife found out and watching our photos wanted
> > to zoom out a bit. Then she just rotated the scrollwheel a lot
> > and expected the zoom to happen. What did happen was that
> > as the there was no apparent response she tried again, and again.
> >
> > Finally the box probably was out of swap space (2GB RAM) and crashed
> > miserably.
> >
> > This is not the expected behavior from a Linux box using a graphics
> > viewer and I now wonder if there is something I can do about it?
> > Kernel parameters?
> > Kview patch?
> > New wife ;-)
> >
> > Best
> > Dag
> 
> 
> If the app has used up all memory, then there is not a great deal
> that the kernel can do about it.
> 
> The oom-killer ideally I suppose should terminate your kview process
> and the machine should continue normally after a fashion. How did
> it actually die? Any kernel messages?

Thanks for responding to this.

No messages.

Behaved like it was randomly killing other processes?? It was actually still
swapping furiously when I reset the machine (at least the hard disk LED was 
blinking), this after some 10 minutes or so.

At that time the whole desktop had died, also some other processes.

I would also like it to kill the offending process, not others if it can
be avoided.

Is the behavior of the OOM killer configurable? I might have it wrong.

I now set the ulimit -v (max virtual memory) to 512MB in hope of this
protecting my system, but this might get me into trouble when using gimp etc.

Best
Dag

