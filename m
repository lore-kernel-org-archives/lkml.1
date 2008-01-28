Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYA1J0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYA1J0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYA1J0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:26:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbYA1J0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:26:14 -0500
Date: Mon, 28 Jan 2008 10:25:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [RFC PATCH] KGDB: various refactorings
Message-ID: <20080128092556.GB4774@elte.hu>
References: <479CD13D.7070703@web.de> <479CD5BA.80009@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479CD5BA.80009@web.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3334]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Kiszka <jan.kiszka@web.de> wrote:

> Sorry, forgot to refresh for this hunk:
> 
>  - rename CHECK_EXCEPTION_STACK to EXCEPTION_STACK_READY

thanks, applied to x86.git.

minor nit:

>  #ifndef CONFIG_X86_32
> -#define CHECK_EXCEPTION_STACK()
> ((&__get_cpu_var(init_tss))[0].x86_tss.ist[0])
> +#define EXCEPTION_STACK_READY()
> ((&__get_cpu_var(init_tss))[0].x86_tss.ist[0])

not only was the mail in quoted-printable format, but the above part 
also had linewrapping damage :-/ Fixed it up manually but please read:

  Documentation/email-clients.txt

	Ingo
