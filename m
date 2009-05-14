Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZENXNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZENXNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbZENXCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:02:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762628AbZENXCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:02:10 -0400
Date: Thu, 14 May 2009 15:55:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jake Edge <jake@lwn.net>
cc: Ingo Molnar <mingo@elte.hu>, Alan@hera.kernel.org, security@kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, Linux@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       mingo@redhat.com, Arjan@hera.kernel.org, Matt Mackall <mpm@selenic.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
In-Reply-To: <20090514164737.6eaab4f0@chukar>
Message-ID: <alpine.LFD.2.01.0905141553010.3343@localhost.localdomain>
References: <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu>
 <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090514164737.6eaab4f0@chukar>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 May 2009, Jake Edge wrote:
>
> It seems like this should be queued up for stable, yes?  I just saw the
> 2.6.29.4 review patches go out, but this wasn't part of it ...

Well, I was hoping to maybe have actual timing numbers from some better 
hash, in case Matt can make one that is efficient enough. So I committed 
the randomness improvement as a clear _improvement_ over what we had, but 
it may not be the final version.

That said, I guess the same argument can be used for pushing it towards 
stable too. Even if we end up doing something fancier, the patch is 
clearly not any worse than what we have currently.

		Linus
