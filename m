Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYASINx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYASINx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 03:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYASINo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 03:13:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbYASINn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 03:13:43 -0500
Date: Sat, 19 Jan 2008 09:13:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Unify printk strings in fault_32|64.c
Message-ID: <20080119081331.GB12995@elte.hu>
References: <1200716549.5724.150.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200716549.5724.150.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

>  #ifdef CONFIG_X86_32
> -			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx\n",
> +			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx",
>  #else

>  #ifdef CONFIG_X86_32
> -			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
> +			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx",
>  #else

thanks, applied.

	Ingo
