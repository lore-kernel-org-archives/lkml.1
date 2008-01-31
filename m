Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYAaWxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYAaWxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYAaWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:53:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYAaWxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:53:40 -0500
Date: Thu, 31 Jan 2008 23:53:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: remove unneeded round_up
Message-ID: <20080131225325.GA27874@elte.hu>
References: <200801291113.35974.yinghai.lu@sun.com> <200801311244.11206.yinghai.lu@sun.com> <20080131210553.GA15221@elte.hu> <200801311455.48573.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801311455.48573.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> -	if (mem != -1L) {
> -		mem = round_up(mem, align);
> +	if (mem != -1L)
>  		return __va(mem);
> -	}

thanks, applied.

It even reduces the size of the kernel a tiny bit:

   text    data     bss     dec     hex filename
   2963    4149    4352   11464    2cc8 numa_64.o.before
   2949    4149    4352   11450    2cba numa_64.o.after

and it's always a good sign to kernel quality when patches (that change 
functionality) have that effect :)

	Ingo
