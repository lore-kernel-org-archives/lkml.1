Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZF0I11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZF0I11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 04:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZF0I1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 04:27:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:47797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbZF0I1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 04:27:17 -0400
Subject: Re: [tip:perfcounters/urgent] perf stat: Fix multi-run stats
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-566747e6298289c5cb02d4939cb3abf1c4fe7e5a@git.kernel.org>
References: <new-submission>
	 <tip-566747e6298289c5cb02d4939cb3abf1c4fe7e5a@git.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 13:56:30 +0530
Message-Id: <1246091190.2961.10.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 04:36 +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  566747e6298289c5cb02d4939cb3abf1c4fe7e5a
> Gitweb:     http://git.kernel.org/tip/566747e6298289c5cb02d4939cb3abf1c4fe7e5a
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Sat, 27 Jun 2009 06:24:32 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 27 Jun 2009 06:34:37 +0200
> 
> perf stat: Fix multi-run stats
> 
> In multi-run (-r/--repeat) printouts, print out the noise of
> the wall-clock average as well.
> 
> Also, fix a bug in printing out scaled counters: if it was not
> scaled then we should not update the average with -1.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  tools/perf/builtin-stat.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
> 


hmm, why you are keep on changing tools/perf/builtin-stat.c you know my
patches are in queue which I prepared on your request and send pull
request :

http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=commitdiff;h=4e3340cd3087c4228350af04c2fc8f6502eb6ad6

In spite of adding the patches you keep on changing the original file ??

--
JSR

