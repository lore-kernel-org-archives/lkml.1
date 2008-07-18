Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbYGRQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbYGRQrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbYGRQr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:47:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51198 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbYGRQr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:47:28 -0400
Date: Fri, 18 Jul 2008 18:47:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kthread: Reduce stack pressure in create_kthread
	and kthreadd
Message-ID: <20080718164715.GE6875@elte.hu>
References: <4873F074.8010708@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4873F074.8010708@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0905]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Subject: [PATCH 1/1] kthread: Reduce stack pressure in create_kthread and kthreadd
> 
>   * Replace:
>   
>   	set_cpus_allowed(..., CPU_MASK_ALL)
> 
>     with:
> 
>   	set_cpus_allowed_ptr(..., CPU_MASK_ALL_PTR)
> 
>     to remove excessive stack requirements when NR_CPUS=4096.
> 
> Based on linux-2.6.tip/master

applied to tip/core/urgent, thanks Mike.

	Ingo
