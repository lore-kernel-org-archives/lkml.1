Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZGRKR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZGRKR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZGRKR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:17:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59850 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZGRKR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:17:57 -0400
Date: Sat, 18 Jul 2009 12:16:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: jolsa@redhat.com
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] tracing: removing struct module* parameter from
	ftrace_init_module code path
Message-ID: <20090718101653.GC24164@elte.hu>
References: <1247773468-11594-1-git-send-email-jolsa@redhat.com> <1247773468-11594-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247773468-11594-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* jolsa@redhat.com <jolsa@redhat.com> wrote:

> The "struct module*" is not being used in the ftrace_init_module 
> code path, removing it.
>
> wbr,
> jirka
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> ---
>  arch/x86/kernel/ftrace.c |    3 +--
>  include/linux/ftrace.h   |    4 +---
>  kernel/trace/ftrace.c    |   25 +++++++++++--------------
>  3 files changed, 13 insertions(+), 19 deletions(-)

patch didnt apply cleanly to the latest tracing tree:

  http://people.redhat.com/mingo/tip.git/README

and the other bits had some fuzz as well. Mind merging + resending 
this?

	Ingo
