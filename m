Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYGTHV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYGTHV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 03:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYGTHVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 03:21:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40439 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYGTHVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 03:21:15 -0400
Date: Sun, 20 Jul 2008 09:21:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: introduce x86_ops
Message-ID: <20080720072102.GC32168@elte.hu>
References: <200807190207.26077.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807190207.26077.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/e820.c         |    9 +-------
>  arch/x86/kernel/mpparse.c      |   17 ++++------------
>  arch/x86/kernel/setup.c        |    4 +++
>  arch/x86/kernel/visws_quirks.c |   42 +++++++++++++++++++----------------------
>  arch/x86/mach-default/setup.c  |   24 +++++++----------------
>  include/asm-x86/setup.h        |   18 ++++++++++-------
>  6 files changed, 50 insertions(+), 64 deletions(-)

> +extern struct x86_ops *x86_ops;

great cleanup!

one detail: i've renamed x86_ops to x86_quirks (and propagated the 
rename into your subseqent patches as well), because this is really 
something that is not used by normal hardware.

	Ingo
