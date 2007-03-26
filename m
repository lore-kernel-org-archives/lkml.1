Return-Path: <linux-kernel-owner+w=401wt.eu-S965176AbXCZLAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbXCZLAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXCZLAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:00:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965176AbXCZLAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:00:21 -0400
Date: Mon, 26 Mar 2007 13:00:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: arjan@infradead.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm]  vdso print fatal signals: fix compiling error bug in nommu arch
Message-ID: <20070326110008.GA12852@elte.hu>
References: <1174904876.32691.90.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174904876.32691.90.camel@roc-desktop>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu, Bryan <bryan.wu@analog.com> wrote:

> +#ifdef CONFIG_MMU
>  	struct mm_struct *mm = vma->vm_mm;
> +#else
> +	struct mm_struct *mm = 0;
> +#endif

s/0/NULL ?

	Ingo
