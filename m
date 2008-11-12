Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYKLV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYKLV3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYKLV3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:29:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYKLV3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:29:12 -0500
Date: Wed, 12 Nov 2008 22:28:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] ftrace: updates for tip
Message-ID: <20081112212858.GA25295@elte.hu>
References: <20081112212127.455979814@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112212127.455979814@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (4):
>       trace: rename unlikely profiler to branch profiler
>       ftrace: rename unlikely iter_ctrl to branch
>       ftrace: add tracer called branch
>       ftrace: rename trace_unlikely.c file
> 
> ----
>  arch/x86/kernel/vsyscall_64.c     |    2 +-
>  arch/x86/vdso/vclock_gettime.c    |    2 +-
>  include/asm-generic/vmlinux.lds.h |    2 +-
>  include/linux/compiler.h          |   19 ++-
>  kernel/trace/Kconfig              |   10 +-
>  kernel/trace/Makefile             |    7 +-
>  kernel/trace/trace.c              |   16 +-
>  kernel/trace/trace.h              |   34 ++--
>  kernel/trace/trace_branch.c       |  320 +++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_selftest.c     |   23 +++
>  kernel/trace/trace_unlikely.c     |  278 --------------------------------
>  11 files changed, 390 insertions(+), 323 deletions(-)

pulled, thanks Steve!

	Ingo
