Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbZGCPBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbZGCPBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZGCPBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:01:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48161 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751331AbZGCPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:01:37 -0400
Date: Fri, 3 Jul 2009 16:02:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703160230.093e422c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703144754.GA13246@elte.hu>
References: <20090703064518.GA30674@elte.hu>
	<20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
	<20090703091655.GB3902@elte.hu>
	<20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
	<20090703095432.GC21141@elte.hu>
	<20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	<20090703102234.GA32128@elte.hu>
	<20090703114431.37abd528@lxorguk.ukuu.org.uk>
	<20090703131727.GA3207@elte.hu>
	<20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	<20090703144754.GA13246@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's an argument you made on false premises.
> 
> The thing is, my review wasnt about old code being moved around. It 
> was about new code being introduced by you:

Ingo, if you've nothing better to do than quote out of context and be
offensive, perhaps you should go fix voyager support or something
productive instead.

The reply section you are quoting was about the code that was moved from
place to place. I stand by that comment - you don't move code from place
to place and reformat, rework it in one go. It's lousy engineering.

> 
> +       if (copy_from_user(&vw.event, (void __user *)arg, sizeof(struct vt_event)))
> +               return -EFAULT;
> +       /* Highest supported event for now */
> +       if(vw.event.event > VT_MAX_EVENT)
> +               return -EINVAL;
> 
> Same pattern as in the old commit: you used differing styles just 3 
> lines apart in new code and apparently didnt even notice it. So i 
> dont buy your argument at all that you will do 'cleanups later' as 
> your patch shows ignorance of the whole concept.

Which was a draft patch with a question, it hadn't even been compiled and
it was obvious at first glance it contained errors - yet you didn't
notice that just spaces.

> > checkpatch is a tool, not a religion. [...]
> 
> The thing is, you didnt really answer my question whether you 
> consider yourself to be accountable to the same standards of quality 
> as other upstream kernel contributors?

I did answer it, I guess you didn't like the answer ?

> But you are not a newbie driver submitter, are you? Do you consider 
> yourself exempt from accepted rules of cleanliness, for new code you 
> submit?

This wasn't code being submitted - which has been pointed out to you
several times.

> > The message I thought was quite clear about what I was asking for. 
> > The fact you complained about spaces and missed the fact it 
> > couldn't even work was "enlightening" in terms of code review.
> 
> Here, in support of advancing a false argument you materially 

You mean you think its not relevant that you saw spacing and format
differences but couldn't spot the fact the code had obvious errors and
hadn't been compiled ? Its a sketch no more.

> This goes beyond 'spaces'. Type cleanliness is the first and most 
> important thing when designing new interfaces - and you just added a 
> new unclean interface in form of vt_event_wait_ioctl().

See comment #1 made in the very first message to you - it was an initial
draft, and if you'd stop trying to cover the fact you were so space and
formatting obsessed you missed the fact it wasn't even compilable code
perhaps we'd get somewhere useful.

Finally look up "Signed-off-by:", if you think it means "this is code I
think is perfection" you are wrong. I quote

"The sign-off is a simple line at the end of the explanation for the
patch, which certifies that you wrote it or otherwise have the right to
pass it on as a open-source patch."

Period and the draft I posted is exactly that.

Now if you'll pardon me I have real work to do while you macdink
space characters.

Alan
