Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYGPKw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYGPKw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbYGPKwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:52:49 -0400
Received: from r00tworld.com ([212.85.137.21]:50629 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbYGPKwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:52:41 -0400
From: pageexec@freemail.hu
To: David Miller <davem@davemloft.net>
Date: Wed, 16 Jul 2008 12:51:31 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: tiago@assumpcao.org, torvalds@linux-foundation.org, greg@kroah.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Message-ID: <487DEED3.1351.1EF6349A@pageexec.freemail.hu>
In-reply-to: <20080716.033112.193697209.davem@davemloft.net>
References: <487DE059.15123.1EBDA558@pageexec.freemail.hu>, <487DE856.15132.1EDCDAAF@pageexec.freemail.hu>, <20080716.033112.193697209.davem@davemloft.net>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 12:52:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jul 2008 at 3:31, David Miller wrote:

> From: pageexec@freemail.hu
> Date: Wed, 16 Jul 2008 12:23:50 +0200
> 
> > On 16 Jul 2008 at 3:08, David Miller wrote:
> > 
> > > IOW, when we fix security issues, it's simply not even appropriate or 
> > > relevant to you.
> > 
> > i'll ask again: why aren't security fixes that you fix relevant to users
> > of older kernels (as that's what the topic was)?
> 
> Backporting any fix to older kernels is a chore, the further back you
> go, the harder and less fun it is.

it depends on the fix and the context of the code it touches. a one
liner in 2.6.26 may not necessarily have to become a 100 line, multi-file
fix in 2.6.16. look at 28d838cc4dfea980cb6eda0a7409cbf91889ca74 for an
example, that was trivial to backport to many kernel versions before.

also, if you can find a commercial distro whose kernel predates even
yours (i.e., yours is between mainline and a well maintained commercial
one) then you may not actually have such a big problem with backports
even for more complex fixes as you can peek at what the commercial guys
are doing.

in any case, you're answering a different question or i'm failing to see
the logical connection between 'irrelevant' and 'laborious'. basically you
said now that you don't provide security info because it's labourious to
backport fixes, or something like that. i'm afraid there's no such logical
connection. you also didn't answer the question about why you should not
make the life of people doing the actual backports (paid for, commercial,
whatever the trigger word for you is) easier.

> The tipping point is really quick to where someone hacking the kernel
> for fun simply isn't going to do it, nor should they be expected to.
> 
> That's why people who want a stable supported kernel with fixes
> constantly backported have grown accustomed to paying for that service.

and how does that imply that you should not mark security fixes as such?
remember, we're not discussing how backports are done in the world, but
why you're helping them by withholding security information. because if
you admit that you're not, then that's one less reason to withhold this
info.

cheers,
  PaX Team

