Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZAEMzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZAEMzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZAEMyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:54:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47569 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbZAEMys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:54:48 -0500
Date: Mon, 5 Jan 2009 13:54:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: cleanup for arch_reinit_sched_domains()
Message-ID: <20090105125435.GA1023@elte.hu>
References: <4961EA06.7070002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4961EA06.7070002@cn.fujitsu.com>
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

> Impact: cleanup
> 
> - Make arch_reinit_sched_domains() static. It was exported to be used in
>   s390, but now rebuild_sched_domains() is used instead.
> 
> - Make it return void.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/sched.h |    1 -
>  kernel/sched.c        |    9 +++------
>  2 files changed, 3 insertions(+), 7 deletions(-)

applied to tip/sched/urgent, thanks!

	Ingo
