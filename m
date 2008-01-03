Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbYACJzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbYACJzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYACJzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:55:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48258 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbYACJzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:55:02 -0500
Date: Thu, 3 Jan 2008 10:54:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/20] x86: Make ptrace.h safe to include from
	assembler code
Message-ID: <20080103095452.GA21003@elte.hu>
References: <20080103149.088038000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103149.088038000@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <ak@suse.de> wrote:

> Index: linux/include/asm-x86/ptrace-abi.h
> ===================================================================
> --- linux.orig/include/asm-x86/ptrace-abi.h
> +++ linux/include/asm-x86/ptrace-abi.h
> @@ -80,6 +80,7 @@
>  
>  #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
>  
> +#ifndef __ASSEMBLY__

hm, this patch misses a rationale - what assembly code includes 
ptrace-abi.h directly or indirectly? Did you see any build breakage with 
x86.git that requires this? (if yes then please send me the .config)

	Ingo
