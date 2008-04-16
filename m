Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbYDPJf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbYDPJf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 05:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYDPJfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 05:35:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33500 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYDPJfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 05:35:20 -0400
Date: Wed, 16 Apr 2008 11:35:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: cleanup early per cpu variables/accesses v2
Message-ID: <20080416093505.GG5343@elte.hu>
References: <20080415233551.964024000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415233551.964024000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mike Travis <travis@sgi.com> wrote:

>   * Introduce a new PER_CPU macro called "EARLY_PER_CPU".  This is
>     used by some per_cpu variables that are initialized and accessed 
>     before there are per_cpu areas allocated.
> 
>   * Small change in kernel/sched.c to remove another 512 bytes from 
>   the stack.

thanks Mike, i have picked your patches up.

	Ingo
