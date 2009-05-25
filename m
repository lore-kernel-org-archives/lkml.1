Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZEYTRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZEYTRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZEYTRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:17:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbZEYTRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:17:08 -0400
Date: Mon, 25 May 2009 12:14:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <4A1AE5CC.1000209@cs.helsinki.fi>
Message-ID: <alpine.LFD.2.01.0905251212250.3435@localhost.localdomain>
References: <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org>
 <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI> <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com> <20090525114127.GE24071@wotan.suse.de>
 <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0905250930530.3435@localhost.localdomain> <4A1AE5CC.1000209@cs.helsinki.fi>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 May 2009, Pekka Enberg wrote:
> 
> We can do that later but then we need to fix up vmalloc_init(). There's
> actually a patch floating around to do that.

Hey, all my suggestions were definitely for the "do it later". I'd hate to 
have this blow up to one large patch. I'm perfectly ok with the patch I 
replied to, I was more thinking that maybe there is then room for further 
(independent) fixups too.

So [vmalloc|pidhash|vfs_caches_eary]_init all fall under the "let's look 
at that too. If we start off with just the scheduler init ordering, that's 
good.

			Linus
