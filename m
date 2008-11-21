Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYKUPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYKUPY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbYKUPYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:24:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbYKUPYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:24:02 -0500
Date: Fri, 21 Nov 2008 16:23:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] cpumask: x86: Introduce cpumask_of_{node,pcibus}
	to replace {node,pcibus}_to_cpumask
Message-ID: <20081121152358.GA21377@elte.hu>
References: <20081121104450.5AB09DDEE8@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121104450.5AB09DDEE8@ozlabs.org>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> 
> Impact: New APIs
> 
> The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
> return a pointer to a struct cpumask.  Part of removing cpumasks from
> the stack.
> 
> Also makes __pcibus_to_node take a const pointer.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/include/asm/pci.h      |   10 ++++++++--
>  arch/x86/include/asm/topology.h |   35 +++++++++++++++++++++++------------
>  arch/x86/kernel/setup_percpu.c  |    8 ++++----
>  3 files changed, 35 insertions(+), 18 deletions(-)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
