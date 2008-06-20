Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbYFTPDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYFTPDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbYFTPDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:03:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49441 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886AbYFTPDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:03:30 -0400
Date: Fri, 20 Jun 2008 17:03:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: simplify x86_mpparse dependency check
Message-ID: <20080620150305.GB17373@elte.hu>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806190018.45944.yhlu.kernel@gmail.com> <200806191213.10312.yhlu.kernel@gmail.com> <200806200733.31477.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806200733.31477.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> [PATCH] x86: simplify x86_mpparse dependency check
> 
> "Maciej W. Rozycki" <macro@linux-mips.org> said:
> 
> > Given X86_64 selects X86_LOCAL_APIC I am not sure the redundancy seen
> >above does not actually obscure the logic behind...  I think:
> >
> >       depends on X86_LOCAL_APIC && !X86_VISWS
> >
> >would be clearer and get the same.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/mpparse - thanks Yinghai.

	Ingo
