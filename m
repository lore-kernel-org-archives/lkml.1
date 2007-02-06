Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXBFXzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXBFXzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965609AbXBFXze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:55:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55930 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965606AbXBFXz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:55:29 -0500
Date: Tue, 6 Feb 2007 15:55:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170804983.29759.1051.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702061550010.8424@woody.linux-foundation.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org> 
 <1170803515.29759.1032.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
 <1170804983.29759.1051.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, David Woodhouse wrote:
>
> Really, if our config is set up in sensible submenus (as in general it
> _is_), the "see everything" behaviour really isn't bad.

There are two fundamental problems with that statement:

 - no, it really isn't always

   Quite often, our Kconfig files have dependencies that are about where 
   the *code* exists, rather than about some nice hierarchical system.

   Think of it this way: would you use a programming language that didn't 
   allow you anything but totally hierarcical language constructs? No sane 
   person would - because real life isn't hierarchical. Yes, there are 
   many things that are, but not all things are.

   Example: many cryptographic algorithms are in crypto/. But then a lot 
   of them ARE NOT. They are in arch/so-and-so/crypto/ or similar. Notice? 

   NOT HIERARCHICAL.

 - I don't use menus at all. I use the good old textual "make oldconfig". 
   Trust me, I _want_ those irrelevant questions gone. They aren't "grayed 
   out".

So you seem to have this *wish* that real life was different than it is. 
But we aren't hierarchical, and even if we were, it *still* wouldn't work 
the way you want things to work.

		Linus "reality bites" Torvalds
