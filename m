Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbZAIXHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbZAIXHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbZAIXHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:07:10 -0500
Received: from 1wt.eu ([62.212.114.60]:1374 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbZAIXHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:07:06 -0500
Date: Sat, 10 Jan 2009 00:06:41 +0100
From: Willy Tarreau <w@1wt.eu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       ben@zeus.com, jarkao2@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090109230641.GD4819@1wt.eu>
References: <49677074.5090802@cosmosbay.com> <20090109185448.GA1999@1wt.eu> <4967B8C5.10803@cosmosbay.com> <20090109212400.GA3727@1wt.eu> <20090109220737.GA4111@1wt.eu> <4967CBB9.1060403@cosmosbay.com> <20090109221744.GA4819@1wt.eu> <20090109224258.GA10257@ioremap.net> <20090109225010.GB4819@1wt.eu> <20090109230124.GA11592@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109230124.GA11592@ioremap.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 02:01:24AM +0300, Evgeniy Polyakov wrote:
> On Fri, Jan 09, 2009 at 11:50:10PM +0100, Willy Tarreau (w@1wt.eu) wrote:
> > Well, I'm now trying to educate myself on the send part. It's still
> > not very clear to me and I'd like to understand a little bit better
> > why we have this corruption problem and why there is a difference
> > between sending segments from memory and sending them from another
> > socket where they were already waiting.
> 
> printks are the best choice, since you will get exactly what you are
> looking for instead of deciphering what developer or code told you.

I know, but as I told in an earlier mail, it was not even clear to
me what function were called. I have made guesses but that's quite
hard when you don't know the entry point. I think I'm not too far
from having discovered the call chain. Understanding it will be
another story, of course ;-)

> > I think I'll put printks everywhere and see what I can observe.
> > Knowing about the GSO/SG workaround already helps me enable/disable
> > the bug.
> 
> I wish I could also be capable to disable the bugs... :)

Me too :-)
Here we have an opportunity to turn it on/off, let's take it !

Willy

