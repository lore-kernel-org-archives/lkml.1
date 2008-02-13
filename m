Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbYBMSLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbYBMSLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYBMSKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:10:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYBMSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:10:34 -0500
Date: Wed, 13 Feb 2008 10:09:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roel Kluin <12o3l@tiscali.nl>
cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       David Miller <davem@davemloft.net>, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <47B32510.20200@tiscali.nl>
Message-ID: <alpine.LFD.1.00.0802131002250.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
 <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org> <47B32510.20200@tiscali.nl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Feb 2008, Roel Kluin wrote:
> 
> In nature there is a lot of duplication: several copies of genes can exist
> and different copies may have a distinct evolution.

This is true of very complex animals, but much less so when looking at 
things like bacteria (and arguably, any current sw project is closer to 
bacteria in complexity than anything mammalian).

In bacteria (and viruses), duplication of DNA/RNA is a big cost of living 
in general, and as a result there is *much* less junk DNA. So in an 
evolutionary sense, it's much closer to what the kernel should have (with 
occasional duplication of code and interfaces to allow new functionality, 
but rather aggressive pruning of the excess baggage).

In other words, all of these choices are a matter of "balance". In some 
areas, excess code is not a sufficient downside, and we keep even broken 
source code around with no actual function, "just because" (or rather, 
because the cost of carrying it around is so small that nobody cares). 

That's true in the kernel as in biology: check out not just deprecated 
code, but the drivers and other odds-and-ends that are explicitly marked 
as non-coding DNA (we just happen to call them BROKEN in our Kconfig).

			Linus
