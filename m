Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYLLHLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYLLHLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYLLHL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:11:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45300 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYLLHLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:11:25 -0500
Date: Fri, 12 Dec 2008 08:11:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, eranian@googlemail.com
Subject: Re: [patch 2/3] x86, bts: provide in-kernel branch-trace interface
Message-ID: <20081212071105.GD7589@elte.hu>
References: <20081211134959.A13599@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211134959.A13599@sedona.ch.intel.com>
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


> --- gits.orig/include/linux/sched.h	2008-12-11 10:45:10.000000000 +0100
> +++ gits/include/linux/sched.h	2008-12-11 11:20:54.000000000 +0100
> @@ -1187,6 +1187,7 @@
>  	 * The buffer to hold the BTS data.
>  	 */
>  	void *bts_buffer;
> +    size_t bts_size;
>  #endif /* CONFIG_X86_PTRACE_BTS */

btw., this was whitespace damaged, i fixed that.

question: how does ->bts_buffer and ->bts_size behave across 
fork()/clone() ? I dont see it explicitly cleared in fork.c.

	Ingo
