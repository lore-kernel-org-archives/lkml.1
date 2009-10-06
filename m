Return-Path: <linux-kernel-owner+w=401wt.eu-S933833AbZJFWWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833AbZJFWWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933825AbZJFWWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:22:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933782AbZJFWV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:21:58 -0400
Date: Tue, 6 Oct 2009 15:19:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <1254864803.6035.25.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>  <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>  <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <1254864803.6035.25.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Benjamin Herrenschmidt wrote:
> 
> Sure, when doing the stuff ourselves. Again, the problem is user
> reports. Being able to distinguish between a 2.6.x "release" kernel and
> anything else would be of value, at least to me.

Why are you arguing? CONFIG_LOCALVERSION_AUTO gives exactly that?

Also, why do you think that "release" is any special? All the same things 
are true about "is it -rc1 or is it -rc1-351-g58e57fb? When it comes to a 
bug-report, the difference between the two can be huge.

> I disagree. I understand the linearity problem. My point isn't about
> having the Makefile provide with any kind of precise "pointer" into that
> tree for non-release, but really only to differenciate a release from
> anything else.

And your point is totally destroyed by any amount of thinking. Which you 
clearly didn't do.

I repeat: there are tons of kernels that would not be based directly on 
that "-rc0" commit. You would confuse _those_ cases even more, because you 
would now think that they are somehow "release" kernels.

And the fact is, NONE OF YOUR BLATHERING has in any way shown why people 
shouldn't just use CONFIG_LOCALVERSION_AUTO.

I keep on returning to that, and harping on it, but the point is, WE 
ALREADY SOLVED THIS PROBLEM. Every single person who asks for a -rc0 tag 
is just being stupid. You already have a much superior solution.

So don't ask me for something _stupid_, when you already have the smart 
thing!

		Linus
