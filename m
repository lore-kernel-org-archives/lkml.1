Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbZHSKLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbZHSKLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 06:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbZHSKLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 06:11:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZHSKLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 06:11:42 -0400
Date: Wed, 19 Aug 2009 12:11:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] Blackfin: Fix link errors with binutils 2.19 and GCC
	4.3
Message-ID: <20090819101132.GA27405@elte.hu>
References: <20090818145801.GA32343@elte.hu> <8bd0f97a0908181447i66a8571fg152868c8ec4233b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0908181447i66a8571fg152868c8ec4233b5@mail.gmail.com>
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


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Tue, Aug 18, 2009 at 10:58, Ingo Molnar wrote:
> > Not sure whether this has been reported/fixed before.
> >
> > Today I built a Blackfin tool-chain from scratch for -tip testing,
> > and it triggers:
> >
> >  arch/blackfin/kernel/vmlinux.lds:1238: undefined section `.data_a_l1' referenced in expression
> >
> > and:
> >
> >  arch/blackfin/kernel/vmlinux.lds:1238: undefined section `.text_data_l1'
> > referenced in expression
> >
> > Now i dont have any way to test this linker script, but it now at
> > least builds fine after fixing what appears to be typos in those
> > assert statements.
> 
> they're def typos made when i copy & pasted earlier lines.  but 
> binutils-2.17 apparently doesnt mind which is why i didnt notice.  
> ive merged this into the Blackfin tree, thanks

yeah, i used binutils-2.19.1.

	Ingo
