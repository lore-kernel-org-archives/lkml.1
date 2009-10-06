Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbZJFPyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbZJFPyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbZJFPyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:54:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758050AbZJFPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:54:03 -0400
Date: Tue, 6 Oct 2009 08:51:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <20091006153632.GA29795@elte.hu>
Message-ID: <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Ingo Molnar wrote:
> 
> hm, i think you ignored (or missed, or found irrelevant) my first 
> suggested variant:

No, I didn't ignore it, it just showed that you didn't know what you were 
thinking about.

>  v2.6.31
>  v2.6.31+
> 
> The '+' sign says that it's more than .31.

No. It shows no such thing. Because it DOES NOT EXIST in other peoples 
trees until they rebase on top of mine.

Unless:

> _That_ i think is a lot harder to confuse with the real .31 than a 
> v2.6.31-1234-g16123c4 version string.

.. are you saying that it would be just some automatically generated 
thing, just a crippled form of CONFIG_LOCALVERSION_AUTO? Kind of a 
CONFIG_LOCALVERSION_AUTO_SHORTFORM?

If so, then I don't hate "v2.6.31+", but at the same time, that single 
plus-sign tells _so_much_ less than v2.6.31-1234-g16123c4 that I think 
it's really sad and crippled. 

Is it so hard to teach people what "v2.6.31-1234-g16123c4" means? It's not 
like it's very complicated, and it's not like it's not visually very 
distinct indeed from the tagged release case (which is just "v2.6.31").

I'd love to use "+" instead of "-", but I was thinking that there are 
various version things that get unhappy about special characters like 
that, so we've always used '-' as the separator (since we've always used 
it).

So I'm _entirely_ open to changing how 'CONFIG_LOCALVERSION_AUTO' works, 
or extending on that notion. 

What I'm _not_ open to doing is to add made-up commits that change the 
top-level Makefile at non-release points. Because that way really does lie 
insanity.

		Linus
