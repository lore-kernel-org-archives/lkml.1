Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYKDJBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYKDJBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYKDJBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:01:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38278 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbYKDJBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:01:24 -0500
Date: Tue, 4 Nov 2008 10:01:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: signal_64: remove unused code in
	__setup_rt_frame()
Message-ID: <20081104090107.GC23790@elte.hu>
References: <490FC015.7080707@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490FC015.7080707@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0037]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> sizeof(*set) is always 8 on x86_64.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/signal_64.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)

applied to tip/x86/signal, thanks!

	Ingo
