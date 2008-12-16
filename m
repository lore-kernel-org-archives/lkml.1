Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758831AbYLPWHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbYLPWHZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYLPWHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:07:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYLPWHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:07:07 -0500
Date: Tue, 16 Dec 2008 23:06:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: signal: use signal_fault() in sys_sigreturn()
Message-ID: <20081216220657.GD14787@elte.hu>
References: <49482568.3020108@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49482568.3020108@ct.jp.nec.com>
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
> Call signal_fault() in error route of sys_sigreturn().
> Change log level to KERN_EMERG if current is init.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/signal.c |   15 +++------------
>  1 files changed, 3 insertions(+), 12 deletions(-)

applied your three patches to tip/x86/signal:

 8bee3f0: x86: ia32_signal: use proper macro __USER32_DS
 d0b48ca: x86: ia32_signal: use __put_user() instead of __copy_to_user()
 ae417bb: x86: signal: use signal_fault() in sys_sigreturn()

thanks!

	Ingo
