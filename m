Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbYKRP4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbYKRP4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKRP4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:56:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47707 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYKRP4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:56:33 -0500
Date: Tue, 18 Nov 2008 16:56:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH v2 2/5] x86: ia32_signal: introduce COPY_SEG_STRICT
Message-ID: <20081118155614.GB2852@elte.hu>
References: <491E4101.7010405@ct.jp.nec.com> <492201F2.1060804@ct.jp.nec.com> <4922027A.4060805@ct.jp.nec.com> <492203AE.7020206@zytor.com> <492207BD.8030807@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492207BD.8030807@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> H. Peter Anvin wrote:
> > Hiroshi Shimamoto wrote:
> >> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >>
> >> Impact: cleanup
> >>
> >> Introduce COPY_SEG_STRICT for ia32_restore_sigcontext().
> >>
> > 
> > I don't like the name _STRICT() for this; if anything it seems to have 
> > quite the opposite meaning.  I would suggest COPY_SEG_USER() or even 
> > COPY_SEG_CPL3().
> 
> Sounds nice.
> I haven't thought about the name. I could not catch wrong meaning from
> _STRICT. My English skill isn't good.

i have changed it to COPY_SEG_CPL3() - no need to resend. Here are the 
patches i've picked up into tip/x86/signal:

 6497760: x86: ia32_signal: change order of storing in setup_sigcontext()
 047ce93: x86: ia32_signal: remove using temporary variable
 8c6e5ce: x86: ia32_signal: cleanup macro RELOAD_SEG
 d71a68d: x86: ia32_signal: introduce COPY_SEG_CPL3
 b78a5b5: x86: ia32_signal: cleanup macro COPY

thanks!

	Ingo
