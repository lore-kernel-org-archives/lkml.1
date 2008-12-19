Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYLSWQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYLSWQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbYLSWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:16:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37727 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYLSWQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:16:24 -0500
Date: Fri, 19 Dec 2008 23:16:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: common.c boot_cpu_stack and boot_exception_stacks
	should be static
Message-ID: <20081219221619.GM2351@elte.hu>
References: <1229706232.7625.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229706232.7625.1.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Impact: cleanup, avoid sparse warnings, reduce kernel size a bit
> 
> Fixes these sparse warnings:
> arch/x86/kernel/cpu/common.c:869:6: warning: symbol 'boot_cpu_stack' was not declared. Should it be static?
> arch/x86/kernel/cpu/common.c:910:6: warning: symbol 'boot_exception_stacks' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/kernel/cpu/common.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

applied to tip/x86/cleanups, thanks!

	Ingo
