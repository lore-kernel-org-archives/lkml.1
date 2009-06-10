Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbZFJUnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbZFJUnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbZFJUnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:43:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43557 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbZFJUnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:43:35 -0400
Date: Wed, 10 Jun 2009 22:43:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mpm@selenic.com,
       npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
Message-ID: <20090610204318.GA8147@elte.hu>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <4A3017D1.5010708@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3017D1.5010708@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Linus Torvalds wrote:
>>
>> On Wed, 10 Jun 2009, Pekka J Enberg wrote:
>
>>> I already have patches for that but they are against the -tip 
>>> tree so I think we ought to just merge this series to mainline 
>>> and fix everything up in subsystem trees for 2.6.31 proper.
>>
>> Hmm. Are there any reasons why the scheduler fixups can't go in 
>> this series? Do they depend on other things in -tip?
>
> The patches are rebased to -tip, yeah. I can do a version against 
> your tree if you want but that will mean merge conflicts for Ingo. 
> Hmm?

I'm a tiny bit nervous about the tested-ness of the patches. Such 
stuff rarely works at first try. But it's obviously nice changes.

What kind of conflicts are there against -tip? The diffstat suggests 
it's mostly in-SLAB code, right? There shouldnt be much to conflict, 
except kmemcheck - which has more or less trivial callbacks there. 

	Ingo
