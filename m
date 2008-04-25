Return-Path: <linux-kernel-owner+w=401wt.eu-S1765636AbYDYU7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765636AbYDYU7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbYDYU7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:59:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091AbYDYU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:59:21 -0400
Date: Fri, 25 Apr 2008 13:51:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
In-Reply-To: <481241DC.3070601@zytor.com>
Message-ID: <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org>
References: <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org>
 <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Apr 2008, H. Peter Anvin wrote:
> 
> Yes, that should work.  It's still ugly, and I have to say I find the
> complexity rather distasteful.  I am willing to be convinced it's worth it,
> but I would really like to see hard numbers.

I really cannot imagine that this kind of pain is *ever* worth it. 

Please give an example of something so important that we'd want to do 
complex code rewriting on the fly. What _is_ the point of imv_cond()?

		Linus
