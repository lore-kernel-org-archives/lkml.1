Return-Path: <linux-kernel-owner+w=401wt.eu-S1762471AbXKTX3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471AbXKTX3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXKTX3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:29:06 -0500
Received: from mx12.go2.pl ([193.17.41.142]:36656 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754982AbXKTX3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:29:05 -0500
Message-ID: <47436E0F.6080003@o2.pl>
Date: Wed, 21 Nov 2007 00:30:23 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Petr Baudis <pasky@suse.cz>
CC: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: gitweb: kernel versions in the history (feature request,	probably)
References: <20071120142042.GA4157@ff.dom.local> <20071120215904.GF1001@machine.or.cz>
In-Reply-To: <20071120215904.GF1001@machine.or.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Baudis wrote, On 11/20/2007 10:59 PM:

>   Hi,
> 
> On Tue, Nov 20, 2007 at 03:20:42PM +0100, Jarek Poplawski wrote:
>> I see gitweb is much more usable (faster) than a few months ago, but
>> there is one thing a bit problematic: in the history of patches I'm
>> very often interested in which kernel version of Linus' tree the patch
>> appeared for the first time. If it's not some big problem, and maybe
>> somebody else finds this useful too, I'd really appreciate adding such
>> a feature.
> 
>   in git terms, you'd like gitweb to provide output for command:
> 
> 	git describe --contains
> 
> This is interesting feature request. I guess the support would be nice,
> though in theory this operation can be a bit resource-intensive in case
> there is not many tags and a lot of development (with uncached
> repository, this query took quite a bit of time on my copy of the kernel
> git tree). Probably this should be an optional feature and somehow dwell
> on a separate page, which doesn't fit too well in the current gitweb
> page structure...
 

I don't know git, but it seems, at least if done for web only, this
shouldn't be so 'heavy'. It could be a 'simple' translation of commit
date by querying a small database with kernel versions & dates. And it
would suffice if it were shown on the commit page only. But, of course,
it's not urgent at all! (And alas I'm no webmaster, so I can miss
something.)

>> Petr, I hope there is no necessity to subscribe to the git list for
>> this one question, so I'd really feel greteful for forwarding, if you
>> find this request reasonable.
> 
>   Yes, there is no necessity - you can post this on the git mailing list
> without subscribing yourself.


Great! I misunderstood the page message. Btw., I know it's not the kernel,
but IMHO there should be some place for it in the MAINTAINERS!

Thanks,
Jarek P.
