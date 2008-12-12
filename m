Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYLLLBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYLLLBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYLLLBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:01:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51917 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbYLLLBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:01:11 -0500
Date: Fri, 12 Dec 2008 12:00:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: uaccess: return value of __{get|put}_user() can
	be int
Message-ID: <20081212110049.GB32640@elte.hu>
References: <493DE38E.60505@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493DE38E.60505@ct.jp.nec.com>
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
> The type of return value of __{get|put}_user() can be int.
> There is no user to refer the return value of __{get|put}_user() as long.
> This reduces code size a bit on 64-bit.
> 
> $ size vmlinux.*
>    text	   data	    bss	    dec	    hex	filename
> 4509265	 479988	 673588	5662841	 566879	vmlinux.new
> 4511462	 479988	 673588	5665038	 56710e	vmlinux.old
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/include/asm/uaccess.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied to tip/x86/mm, thanks!

	Ingo
