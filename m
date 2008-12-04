Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYLDPjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYLDPjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYLDPja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:39:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbYLDPja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:39:30 -0500
Date: Thu, 4 Dec 2008 16:34:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.28-rc6: early panic with boot option "nosmp"
Message-ID: <20081204153411.GA18306@elte.hu>
References: <20081204022806.GA29293@localhost> <20081204101343.GO6703@one.firstfloor.org> <20081204120214.GA30833@localhost> <20081204123335.GP6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204123335.GP6703@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > The exception raised on dereferencing mpf or mpf_found.
> 
> This obvious patch should fix it then. Does it?
> 
> --
> 
> Fix early exception in __get_smp_config with nosmp
> 
> Bail out early when there is no MP table.
> 
> Reported by Wu Fengguang
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/kernel/mpparse.c |    3 +++
>  1 file changed, 3 insertions(+)

applied to tip/x86/urgent, thanks Andi!

	Ingo
