Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbZCTKVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbZCTKVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762092AbZCTKVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:21:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40276 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761972AbZCTKVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:21:18 -0400
Date: Fri, 20 Mar 2009 11:20:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] blktrace: various cleanups and fixes
Message-ID: <20090320102058.GC6256@elte.hu>
References: <49C2F599.3060306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2F599.3060306@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> While trying to use blktrace in -tip tree, I encounted kernel NULL 
> dereference, so I looked into the code, and then found some other 
> bugs.
> 
> This patchset is part 1, and I have some other pending fixes.
> 
> Each patch is small and straightforward, and should be easy to review:
> 
> [PATCH 1/7] blktrace: fix possible memory leak
> [PATCH 2/7] blktrace: make blk_tracer_enabled a bool flag
> [PATCH 3/7] blktrace: remove blk_probe_mutex
> [PATCH 4/7] blktrace: don't increase blk_probes_ref if failed to setup blk trace
> [PATCH 5/7] blktrace: report EBUSY correctly
> [PATCH 6/7] blktrace: remove sysfs_blk_trace_enable_show/store()
> [PATCH 7/7] blktrace: avoid accessing NULL bdev->bd_disk
> ---
>  blktrace.c |  154 +++++++++++++++++--------------------------------------------
>  1 file changed, 45 insertions(+), 109 deletions(-)
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Nice fixes. Applied to tip:tracing/blktrace, thanks!

	Ingo
