Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbZHSLq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbZHSLq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZHSLqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:46:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42371 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZHSLqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:46:54 -0400
Date: Wed, 19 Aug 2009 13:46:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org
Subject: Re: Next Aug 19: s390 build failure (arch/s390/kernel/built-in)
Message-ID: <20090819114646.GB32317@elte.hu>
References: <20090819190233.86e78493.sfr@canb.auug.org.au> <4A8BDE59.2010400@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8BDE59.2010400@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0952]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sachin Sant <sachinp@in.ibm.com> wrote:

> Today's next build failed on s390 with following errors.
>
>  LD      .tmp_vmlinux1
> arch/s390/kernel/built-in.o: In function `trace_syscall_exit':
> include/trace/syscall.h:21: undefined reference to `__tracepoint_syscall_exit'
> include/trace/syscall.h:21: undefined reference to `__tracepoint_syscall_exit'
> arch/s390/kernel/built-in.o: In function `trace_syscall_enter':
> include/trace/syscall.h:14: undefined reference to `__tracepoint_syscall_enter'
> include/trace/syscall.h:14: undefined reference to `__tracepoint_syscall_enter'
> make: *** [.tmp_vmlinux1] Error 1

Could you please send the .config that triggers this?

Thanks,

	Ingo
