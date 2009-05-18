Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbZERRAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbZERRAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZERRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:00:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956AbZERRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:00:05 -0400
Date: Mon, 18 May 2009 09:58:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <20090518164921.GA6903@elte.hu>
Message-ID: <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Ingo Molnar wrote:
> 
> hm - i've Cc:-ed Jeff & Viro. The background is that Sparse and LLVM 
> barfed on the current construct and Al strongly advocated this 
> solution, see:

I know the background.

Did you read my email?

Did you see my one-line patch that fixes the same problem WITHOUT THE 
INSANITY?

Yes, Al is mostly right. In this case he is wrong. (Ab-)Using unions for 
something like this is crazy, since the code doesn't want a union of 
overlapping data, it wants two consecutive data structures.

And I'm not saying that my one-liner is necessarily the only way to fix 
it. But it's a _better_ way than the crazy way you merged.

		Linus
