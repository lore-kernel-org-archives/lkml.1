Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbYFSJDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbYFSJDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYFSJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:03:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYFSJDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:03:41 -0400
Date: Thu, 19 Jun 2008 11:03:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make 64bit identify_cpu use cpu_dev
Message-ID: <20080619090323.GA1575@elte.hu>
References: <200806180215.53755.yhlu.kernel@gmail.com> <20080618141759.GG11501@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618141759.GG11501@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > may need to move some functions to common.c later
> > 
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> applied to tip/x86/cpu, thanks Yinghai.

-tip testing found a boot failure on 64-bit, the bootup just hangs early 
during bootup. I bisected it down to this patch and reverting the patch 
solves the lockup.

Here is the config that triggers it:

 http://redhat.com/~mingo/misc/config-Thu_Jun_19_10_11_15_CEST_2008.bad

	Ingo
