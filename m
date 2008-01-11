Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYAKHjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYAKHjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 02:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYAKHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 02:39:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYAKHjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 02:39:12 -0500
Date: Fri, 11 Jan 2008 08:38:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 early_idt_handler improvements
Message-ID: <20080111073851.GA25207@elte.hu>
References: <20080111060705.9EAF126F9A9@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111060705.9EAF126F9A9@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> It's not too pretty, but I found this made the "PANIC: early 
> exception" messages become much more reliably useful: 1. print the 
> vector number, 2. print the %cs value, 3. handle error-code-pushing vs 
> non-pushing vectors.

thanks, applied.

since these printouts are only useful if we have early-printk 
capabilities enabled, i made it dependent on CONFIG_EARLY_PRINTK.

I also made EARLY_PRINTK selectable on 64-bit as well. (for some unknown 
reason it was unconditionally built into 64-bit (unlike 32-bit where it 
is selectable on EMBEDDED))

	Ingo
