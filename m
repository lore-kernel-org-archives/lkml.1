Return-Path: <linux-kernel-owner+w=401wt.eu-S1031344AbXFHSUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031344AbXFHSUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968903AbXFHSUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:20:25 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:47649 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762787AbXFHSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:20:24 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Date: Fri, 8 Jun 2007 20:21:41 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jeff@garzik.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <20070607162251.5f291325@the-village.bc.nu> <20070608020730.GD23290@havoc.gtf.org> <18024.47852.272454.21519@stoffel.org>
In-Reply-To: <18024.47852.272454.21519@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706082021.42698.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 June 2007, John Stoffel wrote:
> Jeff> On Thu, Jun 07, 2007 at 09:56:06PM -0400, John Stoffel wrote:
> >> Thinking about it more, I wonder if Krysztof is bitching more about
> >> the tab width of 8 characters?   I know that it ticks me off,
> 
> Jeff> Even if he is, _that_ is definitely not getting changed.
> 
> Oh sure... I know that part is written in stone.  

Yes, and as a person doing Linux code review for 12 years now,
I'm really thankful for it. 8 char tab, 80 column rule and 25-50 lines
of code per function actually enable effective review of code snippets.
Because you can see more code flow per patch.

And enables high code reuse. If you can get within 1-5min, 
what a functions does and match it with your actually 
written down last 20 code lines, you just reuse it more often.

If you have more to choose from, you reuse naturally. 
Personally I find best candidates by code position in tree and 
function signature.

> Jeff> If code starts creeping way right due to indentation levels,
> Jeff> create a new function.
> 
> Sure... compilers are good, us humans haven't gotten much better, make
> it easier on us and harder on the computer.   

Yes, let compile remove all the abstraction overhead. 
GCC does a pretty good job there, I think.

I recently analyzed some code and it took much, much longer (factor 2-3), 
because of laxer coding rules similiar to the ones you suggest.

I even asked the developers, who wrote that code and to ones who work 
daily with that code base and they had the same problems. They all couldn't 
explain the "Why?" only the "How?". Not to mention, that this was a core 
component.

After refactoring some big messy parts into smaller functions,
identical, missing, unhandled cases became visible, inappropriate usages
were identified and even some loops could be removed.

Now try to find such problems within Linux. They should be a small percentage 
and not within core components.

So a big THANKS to all the code cops here: You actually make the 
	damn fast change rate of Linux possible by keeping the base clean 
	and neat.

Best Regards

Ingo oeser
