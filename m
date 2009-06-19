Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbZFSQ1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbZFSQ1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFSQ1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:27:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35050 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbZFSQ1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:27:25 -0400
Date: Fri, 19 Jun 2009 18:27:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/6] perf_counter: tools: Makefile tweaks for 64-bit
	powerpc
Message-ID: <20090619162718.GB15197@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <19000.55666.866148.559620@cargo.ozlabs.ibm.com> <20090618091334.GB21191@elte.hu> <19003.18793.605755.277949@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19003.18793.605755.277949@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > Note, i left out this bit from the commit - we need to find a 
> > better solution than to allow ugly warnings on PowerPC.
> > 
> > Could we use the kernel's u64 type directly perhaps? That would 
> > allow us to change all __u64 to u64 in all of tools/perf/ which 
> > is a nice clean-up in any case.
> 
> This is userspace, we can use "u64" however we like. :) I'll cook 
> up a patch to add "typedef unsigned long long u64" and change 
> __u64 to u64.

Thanks, i've applied the patch. Note, it crossed with a few changes 
from Peter - i fixed up the conflicts - please double check whether 
it's still fine on PowerPC too.

	Ingo
