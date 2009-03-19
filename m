Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbZCSKWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbZCSKWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZCSKWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:22:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbZCSKV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:21:58 -0400
Date: Thu, 19 Mar 2009 11:21:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Microblaze linux support
Message-ID: <20090319102142.GA2579@elte.hu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <20090319072256.GA5069@elte.hu> <49C213A2.4040609@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C213A2.4040609@monstr.eu>
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


* Michal Simek <monstr@monstr.eu> wrote:

> WARNING: externs should be avoided in .c files
> #92: FILE: arch/microblaze/kernel/microblaze_ksyms.c:27:
> +extern void __ashldi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #93: FILE: arch/microblaze/kernel/microblaze_ksyms.c:28:
> +EXPORT_SYMBOL(__ashldi3);
> 
> WARNING: externs should be avoided in .c files
> #94: FILE: arch/microblaze/kernel/microblaze_ksyms.c:29:
> +extern void __ashrdi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #95: FILE: arch/microblaze/kernel/microblaze_ksyms.c:30:
> +EXPORT_SYMBOL(__ashrdi3);
> 
> WARNING: externs should be avoided in .c files
> #96: FILE: arch/microblaze/kernel/microblaze_ksyms.c:31:
> +extern void __divsi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #97: FILE: arch/microblaze/kernel/microblaze_ksyms.c:32:
> +EXPORT_SYMBOL(__divsi3);
> 
> WARNING: externs should be avoided in .c files
> #98: FILE: arch/microblaze/kernel/microblaze_ksyms.c:33:
> +extern void __lshrdi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #99: FILE: arch/microblaze/kernel/microblaze_ksyms.c:34:
> +EXPORT_SYMBOL(__lshrdi3);
> 
> WARNING: externs should be avoided in .c files
> #100: FILE: arch/microblaze/kernel/microblaze_ksyms.c:35:
> +extern void __modsi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #101: FILE: arch/microblaze/kernel/microblaze_ksyms.c:36:
> +EXPORT_SYMBOL(__modsi3);
> 
> WARNING: externs should be avoided in .c files
> #102: FILE: arch/microblaze/kernel/microblaze_ksyms.c:37:
> +extern void __mulsi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #103: FILE: arch/microblaze/kernel/microblaze_ksyms.c:38:
> +EXPORT_SYMBOL(__mulsi3);
> 
> WARNING: externs should be avoided in .c files
> #104: FILE: arch/microblaze/kernel/microblaze_ksyms.c:39:
> +extern void __muldi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #105: FILE: arch/microblaze/kernel/microblaze_ksyms.c:40:
> +EXPORT_SYMBOL(__muldi3);
> 
> WARNING: externs should be avoided in .c files
> #106: FILE: arch/microblaze/kernel/microblaze_ksyms.c:41:
> +extern void __ucmpdi2(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #107: FILE: arch/microblaze/kernel/microblaze_ksyms.c:42:
> +EXPORT_SYMBOL(__ucmpdi2);
> 
> WARNING: externs should be avoided in .c files
> #108: FILE: arch/microblaze/kernel/microblaze_ksyms.c:43:
> +extern void __udivsi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #109: FILE: arch/microblaze/kernel/microblaze_ksyms.c:44:
> +EXPORT_SYMBOL(__udivsi3);
> 
> WARNING: externs should be avoided in .c files
> #110: FILE: arch/microblaze/kernel/microblaze_ksyms.c:45:
> +extern void __umodsi3(void);
> 
> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> #111: FILE: arch/microblaze/kernel/microblaze_ksyms.c:46:
> +EXPORT_SYMBOL(__umodsi3);

externs should be in header files.

The rest indeed looks like false positives. Thanks for addressing 
these things so quickly!

	Ingo
