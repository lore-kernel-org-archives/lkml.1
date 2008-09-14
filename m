Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYINNgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYINNgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 09:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYINNgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 09:36:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33237 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbYINNge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 09:36:34 -0400
Date: Sun, 14 Sep 2008 15:36:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/3] x86: signal: get give_sigsegv of setup frames
	together
Message-ID: <20080914133618.GD554@elte.hu>
References: <48CB02C5.4060805@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CB02C5.4060805@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> When setup frame failed, force_sigsegv is called and returns -EFAULT.
> There are same code in ia32_setup_fram(), ia32_setup_rt_frame(),
> __setup_frame() and __setup_rt_frame().
> Get them together.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

applied your three signal code unification patches to tip/x86/signal:

 e6babb6: x86: signal: introduce do_rt_sigreturn()
 2ba48e1: x86: signal: remove unneeded err handling
 3d0aedd: x86: signal: put give_sigsegv of setup frames together

thanks!

	Ingo
