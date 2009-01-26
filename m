Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZAZVxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZAZVxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZAZVwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:52:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZAZVwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:52:55 -0500
Date: Mon, 26 Jan 2009 22:52:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make irqinit_32.c more like irqoinit_64.c
Message-ID: <20090126215235.GA25249@elte.hu>
References: <497C4111.8030904@kernel.org> <20090126124140.GA5812@elte.hu> <20090126141646.GA30919@elte.hu> <497E2408.7050609@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E2408.7050609@kernel.org>
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

> please check
> 
> [PATCH] x86: make irqinit_32.c more like irqinit_64.c -v2

> v2: should use !test_bit() instead of test_bit() with 32bit

> +		if (!test_bit(vector, used_vectors))
> +			set_intr_gate(vector, interrupt[i]);

applied - thanks Yinghai!

	Ingo
