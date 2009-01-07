Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZAGMSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZAGMSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZAGMRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:17:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbZAGMRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:17:32 -0500
Date: Wed, 7 Jan 2009 13:16:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH 2/2] kprobes: check CONFIG_FREEZER instead of CONFIG_PM
Message-ID: <20090107121659.GA16268@elte.hu>
References: <200901062112.29227.rjw@sisk.pl> <200901062115.33286.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901062115.33286.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Check CONFIG_FREEZER instead of CONFIG_PM because kprobe booster
> depends on freeze_processes() and thaw_processes() when CONFIG_PREEMPT=y.
> 
> This fixes a linkage error which occurs when CONFIG_PREEMPT=y, CONFIG_PM=y
> and CONFIG_FREEZER=n.
> 
> Reported-by: Cheng Renquan <crquan@gmail.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/ia64/kernel/kprobes.c |    2 +-
>  arch/x86/kernel/kprobes.c  |    2 +-
>  kernel/kprobes.c           |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

looks good, the x86 bits:

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
