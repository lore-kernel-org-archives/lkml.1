Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYJNQBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYJNQBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJNQA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:00:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYJNQA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:00:56 -0400
Date: Tue, 14 Oct 2008 13:00:42 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v0] header redux: remove sched.h from interrupt.h
Message-ID: <20081014160042.GB15550@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, viro@zeniv.linux.org.uk
References: <20081014154510.GA14588@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014154510.GA14588@x200.localdomain>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 14, 2008 at 07:45:10PM +0400, Alexey Dobriyan escreveu:
> I'm going to send this slightly before -rc1 or right after -rc1.
> 
> It lives at
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/headers.git headers
> 
> Further reduction ideas are welcome.
> 
> 
> 1) remove sched.h from interrupt.h
> 2) remove sched.h from smp_lock.h (interrupt.h => hardirq.h => smp_lock.h)
> 3) for (2) move release_kernel_lock(), reacquire_kernel_lock() to
>    kernel/sched.c -- they're only used by scheduler and low-level enough
>    to now allow in drivers.
> 4) insert sched.h and less-bloated headers where needed.
> 
> [insert recompile redux here]
> [insert *.i bloat redux here]
> [insert cross-compile status here]

I would love to see before and after sizes for debuginfo, i.e. compile
with CONFIG_DEBUG_INFO and check the sizes of the debug sections.

- Arnaldo
