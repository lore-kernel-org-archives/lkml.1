Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0CHXji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:39:38 -0500
Received: from mail.perches.com ([173.55.12.10]:1519 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab0CHXjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:39:37 -0500
Subject: Re: [PATCH] vsprintf.c: Use noinline_for_stack
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <1267929215.1937.18.camel@Joe-Laptop.home>
References: <cover.1267682641.git.joe@perches.com>
	 <20100304143837.af39845d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>
	 <1267911399.849.39.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
	 <1267914654.849.81.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061445490.31447@localhost.localdomain>
	 <alpine.LFD.2.00.1003061455590.31447@localhost.localdomain>
	 <1267918554.849.89.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061540470.23804@localhost.localdomain>
	 <alpine.LFD.2.00.1003061547490.23804@localhost.localdomain>
	 <alpine.LFD.2.00.1003061556420.23804@localhost.localdomain>
	 <1267924214.1937.12.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061755400.23804@localhost.localdomain>
	 <1267929215.1937.18.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 15:39:35 -0800
Message-ID: <1268091575.1925.61.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-06 at 18:33 -0800, Joe Perches wrote:
> On Sat, 2010-03-06 at 18:03 -0800, Linus Torvalds wrote:
> > A few noinlines might be appropriate.
> Mark static functions with noinline_for_stack

It's fine by me that the vsnprintf recursion and
(pr|dev|netdev)_<level> text reduction patches didn't make .34.

I'd like to know what you think necessary to get them into .35.

Perhaps it'd be useful if they could go into -next as-is for a
bit of wider testing.

http://patchwork.kernel.org/patch/83940/
http://patchwork.kernel.org/patch/83724/
http://patchwork.kernel.org/patch/83726/
http://patchwork.kernel.org/patch/83725/


