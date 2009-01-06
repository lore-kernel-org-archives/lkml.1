Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZAFKRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZAFKRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbZAFKRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:17:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56497 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZAFKRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:17:23 -0500
Date: Tue, 6 Jan 2009 11:17:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
Message-ID: <20090106101710.GA22134@elte.hu>
References: <200901051236.281008835@firstfloor.org> <20090104233640.6A7453E6653@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104233640.6A7453E6653@basil.firstfloor.org>
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

> Hugh Dickins noticed that older gcc versions when the kernel is built 
> for code size didn't inline some of the bitops.

Older GCCs have a whole lot more problems than suboptimal inlining 
decisions.

Your patch is wrong because it prevents a good compiler from doing the 
right inlining decisions.

So why should i apply this?

	Ingo
