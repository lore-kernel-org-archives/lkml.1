Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYKTPoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYKTPoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYKTPoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:44:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbYKTPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:43:59 -0500
Date: Thu, 20 Nov 2008 16:43:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] x86: Fixing __cpuinit/__init tangle.
Message-ID: <20081120154354.GA23060@elte.hu>
References: <b9df5fa10811200508h6dc8ec60p1934ece2dde2b426@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10811200508h6dc8ec60p1934ece2dde2b426@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> Impact:	 Fixing __cpuinit/__init tangle.
> 
> This patch removes the following section mismatch warning. A patch set
> was send previously (http://lkml.org/lkml/2008/11/10/407). But
> introduce some other problem, reported by Rufus
> (http://lkml.org/lkml/2008/11/11/46). Then Ingo Molnar suggest that,
> it's best to remove __init from xsave_cntxt_init(void). Which is the
> second patch in this series. Now, this one removes the following
> warning.
> 
> WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x2237): Section
> mismatch in reference from the function cpu_init() to the function
> .init.text:init_thread_xstate()
> The function __cpuinit cpu_init() references
> a function __init init_thread_xstate().
> If init_thread_xstate is only used by cpu_init then
> annotate init_thread_xstate with a matching annotation.
> 
> Thanks.

applied to tip/x86/urgent, thanks Rakib!

	Ingo
