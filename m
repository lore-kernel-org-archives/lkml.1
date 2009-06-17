Return-Path: <linux-kernel-owner+w=401wt.eu-S1765485AbZFQNeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765485AbZFQNeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZFQNem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:34:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56909 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZFQNel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:34:41 -0400
Date: Wed, 17 Jun 2009 15:29:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: open_posix_testsuite: STOP + CONT + wait hang?
Message-ID: <20090617132947.GA6476@redhat.com>
References: <20090525185502.GA20781@redhat.com> <20090526210514.C1C91FC2BD@magilla.sf.frob.com> <20090526213346.GA7073@redhat.com> <20090527005527.B50B7FC36B@magilla.sf.frob.com> <20090602045418.GB8219@us.ibm.com> <f5a7b3810906050843g6cbf5067o5ba1b9e07e5e2f5b@mail.gmail.com> <20090606064749.GA13508@redhat.com> <f5a7b3810906170135q3fd90f8fy8c5e06ab77e26b52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5a7b3810906170135q3fd90f8fy8c5e06ab77e26b52@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, naresh kamboju wrote:
>
> please find inline comments

Thanks Naresh.

> >> ARCH: ARM
> >
> > is it ARM specific? I can't reproduce the problem on x86.
> yes it is specific to ARM. test cases are PASSED on X86-2.6.29 Kernels.

Not good, because I know nothing about arm and don't have the arm machine ;)
Will try to look...

> > If you can reproduce the problem, please send the content of
> > /proc/CHILD_PID/status and /proc/PARENT_PID/status.
>
> i have attached  strace and proc_log
> please review the same.

Thanks.

Could you reproduce without strace, and send the output of /proc/xxx/status ?
I don't really expect we will see something interesting, but just in case.

Also, the output of sysrq-t may help. (the part which relates to these 2
processes).

Oleg.

