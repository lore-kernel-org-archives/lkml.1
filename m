Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbYLHOWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbYLHOWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYLHOWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:22:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYLHOWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:22:10 -0500
Date: Mon, 8 Dec 2008 15:21:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: signal: change type of paramter for
	sys_rt_sigreturn()
Message-ID: <20081208142151.GD14856@elte.hu>
References: <4939D295.6090001@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4939D295.6090001@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: cleanup on 32-bit
> 
> Peter pointed this parameter can be changed.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/include/asm/syscalls.h |    2 +-
>  arch/x86/kernel/signal.c        |    6 ++----
>  2 files changed, 3 insertions(+), 5 deletions(-)

applied to tip/x86/signal, thanks!

	Ingo
