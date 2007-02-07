Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbXBGADu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbXBGADu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXBGADu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:03:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60403 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbXBGADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:03:49 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702061550010.8424@woody.linux-foundation.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
	 <1170803515.29759.1032.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
	 <1170804983.29759.1051.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702061550010.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 00:03:42 +0000
Message-Id: <1170806622.29759.1063.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 15:55 -0800, Linus Torvalds wrote:
> 
> On Tue, 6 Feb 2007, David Woodhouse wrote:
> >
> > Really, if our config is set up in sensible submenus (as in general it
> > _is_), the "see everything" behaviour really isn't bad.
> 
> There are two fundamental problems with that statement:
> 
>  - no, it really isn't always
> 
>    Quite often, our Kconfig files have dependencies that are about where 
>    the *code* exists, rather than about some nice hierarchical system.
> 
>    Think of it this way: would you use a programming language that didn't 
>    allow you anything but totally hierarcical language constructs? No sane 
>    person would - because real life isn't hierarchical. Yes, there are 
>    many things that are, but not all things are.
> 
>    Example: many cryptographic algorithms are in crypto/. But then a lot 
>    of them ARE NOT. They are in arch/so-and-so/crypto/ or similar. Notice? 
> 
>    NOT HIERARCHICAL.

It isn't that far off, and we could improve it if we wanted to. In
_general_ it's quite good already.

>  - I don't use menus at all. I use the good old textual "make oldconfig". 
>    Trust me, I _want_ those irrelevant questions gone. They aren't "grayed 
>    out".
> 
> So you seem to have this *wish* that real life was different than it is. 
> But we aren't hierarchical, and even if we were, it *still* wouldn't work 
> the way you want things to work.

It would work quite nicely in the graphical tools, although you've
thrown me a little by wanting it in the hacker's tool 'oldconfig' too.
You obviously care more about turning stuff _on_ with 'make oldconfig'
while other people who've spoken up seem to care more, as I do, about
turning stuff _off_ that way. If I want my hand held, I'm happy enough
to use the graphical tools.

I think the answer is probably just to go ahead and implement the 'make
oldconfig_noselect' so we can all have what we want.

-- 
dwmw2

