Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbYGPJvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbYGPJvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbYGPJvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:51:23 -0400
Received: from r00tworld.com ([212.85.137.21]:57472 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbYGPJvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:51:23 -0400
From: pageexec@freemail.hu
To: Tiago Assumpcao <tiago@assumpcao.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jul 2008 11:49:45 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487DE059.15123.1EBDA558@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.1.10.0807151832260.2835@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D4A7B.8090403@assumpcao.org>, <alpine.LFD.1.10.0807151832260.2835@woody.linux-foundation.org>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 11:50:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 18:41, Linus Torvalds wrote:

> On Tue, 15 Jul 2008, Tiago Assumpcao wrote:
> > All I ask for is to receive the "There are updates available." message as soon
> > as one security problem is reported, understood and treated by your
> > development part. And that is, the sooner possible, if you please.
> 
> Umm. You're talking to _entirely_ the wrong person.
> 
> The people who want to track security issues don't run my development 
> kernels. They usually don't even run the _stable_ kernels.

how do you *know*?

> They tend to 
> run the kernels from some commercial distribution, and usually one that is 
> more than six months old as far as I - and other kernel developers - are 
> concerned.
> 
> IOW, when we fix security issues, it's simply not even appropriate or 
> relevant to you.

why? what makes you think that a bug fixed in 2.6.26 is not relevant to
2.6.20? do you or anyone else personally verify that? color me impressed
if you do that on every single fix you commit.

> More importantly, when we fix them, your vendor probably 
> won't have the fix for at least another week or two in most cases anyway.

correct, but also irrelevant, see below.

> So ask yourself - what would happen if I actually made a big deal out of 
> every bug we find that could possibly be a security issue. HONESTLY now!

why do you and others keep exaggerating of what is (well, was) expected from
you? what's with this 'big deal' business? can't you image a middle ground
where you simply just state what you know? say, my category 1-2 i talked
about before.

> We'd basically be announcing a bug that (a) may not be relevant to you, 
> but (b) _if_ it is relevant to you, you almost certainly won't actually 
> have fixed packages until a week or two later available to you!
> 
> Do you see?
> 
> I would not actually be helping you. I'd be helping the people you want to 
> protect against!

your argument rests on a fallacy that we discussed already but you keep
coming back with it. what makes you think that people exploiting kernel
bugs *rely* on your marking security bugs as such? they do *not*. they
are smarter (read: domain experts) than you or anyone else on lkml. they
will most likely spot the security issue when you *introduce* it, not
when you *fix* it. in other words, you are only helping the attackers by
withholding security information, not your users.

cheers,
  PaX Team

