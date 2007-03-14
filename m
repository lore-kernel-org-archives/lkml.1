Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbXCNQMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbXCNQMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXCNQMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:12:17 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:35311 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbXCNQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:12:15 -0400
Subject: Re: [PATCH 18/18] Straight file moves
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <Pine.LNX.4.64.0703140837300.9690@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org>
	 <20070314051050.688415057@goodmis.org>
	 <Pine.LNX.4.64.0703140837300.9690@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 12:11:38 -0400
Message-Id: <1173888698.31159.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 08:44 -0700, Linus Torvalds wrote:
> 
> On Wed, 14 Mar 2007, Steven Rostedt wrote:
> >
> > Here's a list of files that were moved from either i386 or x86_64 over
> > to the arch/x86 directory.
> 
> Well, this means that your patch series doesn't actually *compile* as a 
> series.

You're right. I should have kept the "RFC/" part, since the reason for
breaking it up was more for review and comments than to actually apply.


> Also, in case you didn't notice, it's also perfectly fine to have  
> "impure" moves, ie a move that not only renames something, but also 
> changes something (commonly the comments at the top of the file). Maybe 
> you simply didn't have anything like that, but I thought I'd mention it 
> just in case you tried to avoid it on purpose.

There were a couple of "impure moves". But those where done with two
different commits. So the git-diff -M produced a "pure move" and then a
patch against the end result. So no, I didn't put in any effort to make
them all "pure" moves. Git did that for me.

> 
> The reason I really want the whole series to be compileable is that 
> especially with a lot of people using "git bisect", if you have something 
> that doesn't compile in the middle, not only does it show that the series 
> wasn't a series, it also means that you cannot automate the bisect and you 
> need manual intervention.

I usually do always try to make my patches compile for every patch. But
this was a strange case and I wanted it to be more reviewable than
compiling at every stage. But if something can be agreed on, I'll make
sure my next patch series conforms to the "compile at every stage" rule.

Thanks,

-- Steve


