Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbZBSLTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbZBSLTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZBSLTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:19:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbZBSLTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:19:31 -0500
Date: Thu, 19 Feb 2009 12:19:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: syscalls.h: remove asmlinkage from declaration of
	sys_rt_sigreturn()
Message-ID: <20090219111916.GO2354@elte.hu>
References: <499C5C88.7080808@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C5C88.7080808@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup
> 
> asmlinkage for sys_rt_sigreturn() no longer exists in arch/x86/kernel/signal.c.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/include/asm/syscalls.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip:x86/cleanups, thanks Hiroshi!

	Ingo
