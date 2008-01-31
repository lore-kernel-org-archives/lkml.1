Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbYAaJYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbYAaJYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYAaJYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:24:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38790 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYAaJYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:24:06 -0500
Date: Thu, 31 Jan 2008 10:23:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "H. Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>
Subject: Re: [PATCH] lguest: fix mis-merge against hpa's TSS renaming
Message-ID: <20080131092341.GA10841@elte.hu>
References: <200801311800.48359.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801311800.48359.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> --- a/drivers/lguest/x86/core.c	Thu Jan 31 14:50:43 2008 +1100
> +++ b/drivers/lguest/x86/core.c	Thu Jan 31 17:58:44 2008 +1100
> @@ -94,7 +94,7 @@ static void copy_in_guest_info(struct lg
>  	/* Set up the two "TSS" members which tell the CPU what stack to use
>  	 * for traps which do directly into the Guest (ie. traps at privilege
>  	 * level 1). */
> -	pages->state.guest_tss.esp1 = cpu->esp1;
> +	pages->state.guest_tss.sp1 = cpu->esp1;

btw., could you perhaps (later on) rename it to ->sp1, so that all the 
register namings are consistent in the x86 architecture? Might be handy 
for lguest-64 as well :-)

	Ingo
