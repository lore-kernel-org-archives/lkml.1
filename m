Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZEONtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZEONtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZEONt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:49:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60808 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZEONt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:49:28 -0400
Date: Fri, 15 May 2009 15:47:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jake Edge <jake@lwn.net>, Alan@hera.kernel.org, security@kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, Linux@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       mingo@redhat.com, Arjan@hera.kernel.org, Matt Mackall <mpm@selenic.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Message-ID: <20090515134717.GA16389@elte.hu>
References: <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090514164737.6eaab4f0@chukar> <alpine.LFD.2.01.0905141553010.3343@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905141553010.3343@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 May 2009, Jake Edge wrote:
> >
> > It seems like this should be queued up for stable, yes?  I just 
> > saw the 2.6.29.4 review patches go out, but this wasn't part of 
> > it ...
> 
> Well, I was hoping to maybe have actual timing numbers from some 
> better hash, in case Matt can make one that is efficient enough. 
> So I committed the randomness improvement as a clear _improvement_ 
> over what we had, but it may not be the final version.

yep, it was just a quick hack really. If someone can do a stronger 
hash that also happens to be faster i guess we all will be happy 
campers. The performance figures showed room for improvement - how 
well are those hashes optimized? Many thousands of cycles ... is 
that really justified?

> That said, I guess the same argument can be used for pushing it 
> towards stable too. Even if we end up doing something fancier, the 
> patch is clearly not any worse than what we have currently.

Agreed. Havent seen any issues due to it. Jake, mind bouncing the 
commit notification to stable@kernel.org?

	Ingo
