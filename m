Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYHZITU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYHZITU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYHZITL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:19:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbYHZITJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:19:09 -0400
Date: Tue, 26 Aug 2008 10:18:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic - unify smp_spurious/error_interrupt
	declaration
Message-ID: <20080826081853.GA14308@elte.hu>
References: <20080825172726.GC7249@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825172726.GC7249@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> According to entry_64.S we do pass pt_regs pointer
> into interrupt handlers but don't use them. So we
> safetly may merge the declarations.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

applied to tip/irq/sparseirq, thanks Cyrill.

	Ingo
