Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYCUMaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYCUMaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYCUMaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:30:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbYCUMaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:30:02 -0400
Date: Fri, 21 Mar 2008 13:29:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 03/10] sched: add exported arch_reinit_sched_domains()
	to header file.
Message-ID: <20080321122948.GA26733@elte.hu>
References: <20080312173155.703966894@de.ibm.com> <20080312173216.861331041@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312173216.861331041@de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1537]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> Needed so it can be called from outside of sched.c.

thanks, applied.

> +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +extern int arch_reinit_sched_domains(void);
> +#endif

i removed the #ifdefs around this.

	Ingo
