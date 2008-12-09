Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbYLIDRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbYLIDRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYLIDRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:17:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58984 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYLIDRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:17:41 -0500
Date: Tue, 9 Dec 2008 04:17:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix compiling with alpha
Message-ID: <20081209031712.GA9809@elte.hu>
References: <86802c440812050120i6f5557dfo9c05bb43272ec807@mail.gmail.com> <20081205103002.GA5325@elte.hu> <49397CD0.9030301@kernel.org> <20081208142307.GE14856@elte.hu> <20081208150129.GA21496@elte.hu> <493D9A59.2030508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493D9A59.2030508@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix
> 
> can not use irq_desc in stat.c for some arch
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.orgg>
> 
> ---
>  fs/proc/stat.c        |   20 +++++++++++++-------
>  include/linux/irq.h   |    9 ---------
>  include/linux/irqnr.h |   19 ++++++++++++++++---
>  3 files changed, 29 insertions(+), 19 deletions(-)

applied to tip/irq/sparseirq, thanks!

	Ingo
