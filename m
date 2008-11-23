Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbYKWI0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbYKWI0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYKWI0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:26:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYKWI0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:26:45 -0500
Date: Sun, 23 Nov 2008 09:26:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/2] tracing: userspace stacktraces
Message-ID: <20081123082630.GC30453@elte.hu>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1227353328-16104-1-git-send-email-edwintorok@gmail.com>
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


* Török Edwin <edwintorok@gmail.com> wrote:

> Hi,
> 
> I am resending my patches, differrences from previous send:
> * fixed some style issues
> * introduce seq_print_user_ip helper
> * make mangle_path global and document
> * use mangle_path instead of abusing seq_file in trace_seq_path
> * fix subject line and commit messages
> 
> These patches apply on top of tip/master,
> commit 50598e26c1360d4c0edcabc50035d084ee8d3d70
> 
> Török Edwin (2):
>   tracing: add support for userspace stacktraces in tracing/iter_ctrl
>   tracing: identify which executable object the userspace address
>     belongs to
> 
>  Documentation/ftrace.txt     |   16 ++++-
>  arch/x86/kernel/stacktrace.c |   57 +++++++++++++++
>  fs/seq_file.c                |   14 ++++-
>  include/linux/seq_file.h     |    1 +
>  include/linux/stacktrace.h   |    8 ++
>  kernel/trace/trace.c         |  165 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.h         |   10 +++
>  7 files changed, 269 insertions(+), 2 deletions(-)

applied to tip/tracing/stack-tracer - thanks Edwin!

I've got a few comments about certain details - please send delta 
patches on top of these patches to fix those.

	Ingo
