Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYHQRyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYHQRyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYHQRyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:54:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33073 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYHQRyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:54:01 -0400
Date: Sun, 17 Aug 2008 19:53:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Lars Gullik =?iso-8859-1?Q?Bj=F8nnes?= <larsbj@gullik.net>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080817175343.GA7238@elte.hu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <200808162055.45136.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org> <20080817103241.GB21303@elte.hu> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080817173319.GA2450@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> +#define BUILD_BUG_ON_ZERO2(c)    (__BBO(c) - __BBONC(c))
> +#define BUILD_BUG_ON2(c)         (void)BUILD_BUG_ON_ZERO(c)
                                          ^^^^^^^^^^^^^^^^^
Lars Gullik Bjønnes pointed out that this should have been ZERO2 not 
ZERO - but same end result.

	Ingo
