Return-Path: <linux-kernel-owner+w=401wt.eu-S1760553AbZCXNOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbZCXNOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZCXNOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:14:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZCXNOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:14:19 -0400
Date: Tue, 24 Mar 2009 14:13:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/kprobes] x86: kretprobe-booster interrupt
	emulation code fix
Message-ID: <20090324131359.GA13210@elte.hu>
References: <49C7995C.2010601@redhat.com> <tip-b9dad0d2955db059cd92c81c37ddcbef0abc8bf8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-b9dad0d2955db059cd92c81c37ddcbef0abc8bf8@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

>  	regs->ip = trampoline_address;
>  	regs->orig_ax = ~0UL;
> +	regs->gs = 0;

hm, this wont build on 32-bit.

	Ingo
