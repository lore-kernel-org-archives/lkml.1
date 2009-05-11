Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZEKTUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZEKTUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbZEKTU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:20:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbZEKTU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:20:26 -0400
Date: Mon, 11 May 2009 21:20:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix percpu_{to,from}_op()
Message-ID: <20090511192009.GE28684@elte.hu>
References: <4A08652802000078000004F8@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A08652802000078000004F8@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> - the byte operand constraints were wrong for 32-bit
> - the to-op's input operands weren't properly parenthesized
> 
> [ Impact: compilation problem fix ]
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/include/asm/percpu.h |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

applied to x86/urgent, thanks.

Btw., what kind of compilation problem did you experience? Did GCC 
bail out with a constraint error (which version?), or did you get a 
miscompiled kernel?

	Ingo
