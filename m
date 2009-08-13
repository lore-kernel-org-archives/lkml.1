Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZHMIz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZHMIz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZHMIz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:55:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43976 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbZHMIzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:55:25 -0400
Date: Thu, 13 Aug 2009 10:55:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.orga,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
Message-ID: <20090813085505.GA10671@elte.hu>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1250142522.3587.110.camel@pasglop> <20090813160625B.fujita.tomonori@lab.ntt.co.jp> <20090813074131.GH12143@elte.hu> <1250150981.3587.157.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250150981.3587.157.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> > Ben, what's your preference? I waited for your reaction with these 
> > bits, i.e. they are not in tip:core/iommu yet.
> 
> Oh I though they were... discard my previous private mail about 
> missing Ack's then :-)
> 
> I'll review them more in depth hopefully tomorrow but they look 
> good.

Sure - take your time.

> > One variant would be what Fujita suggested: you could pull 
> > core/iommu as a basis (it's a well-tested, problem-free tree at 
> > the moment, with no big risky items), and then pull/apply the 
> > powerpc specific bits from Fujita.
> 
> Or we can have the patches in core/iommu and I pull the whole 
> thing in powerpc-next. [...]

Ok! We could also stage it a bit (one or two weeks) in a separate 
branch and allow a rebase, should you find any bugs during testing?

	Ingo
