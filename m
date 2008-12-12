Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYLLLFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYLLLFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYLLLEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:04:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60781 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbYLLLEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:04:53 -0500
Date: Fri, 12 Dec 2008 12:04:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kill #ifdef for exit_idle()
Message-ID: <20081212110444.GC32640@elte.hu>
References: <493DE3AB.4090409@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493DE3AB.4090409@ct.jp.nec.com>
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
> Introduce helper incline function in arch/x86/include/asm/idle.h
> to remove #ifdefs around exit_idle().
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/include/asm/idle.h |    5 +++++
>  arch/x86/kernel/apic.c      |    6 ------
>  arch/x86/kernel/io_apic.c   |    3 +--
>  3 files changed, 6 insertions(+), 8 deletions(-)

applied to tip/x86/idle, thanks!

	Ingo
