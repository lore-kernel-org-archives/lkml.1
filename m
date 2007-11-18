Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbXKRAmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbXKRAmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 19:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXKRAml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 19:42:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbXKRAmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 19:42:40 -0500
Date: Sun, 18 Nov 2007 01:42:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de
Subject: Re: [patch] Printk kernel version in WARN_ON
Message-ID: <20071118004218.GA26865@elte.hu>
References: <20071117101552.2a7f34cb@laptopd505.fenrus.org> <20071117102720.251107d7.akpm@linux-foundation.org> <20071117103947.5b2052f8@laptopd505.fenrus.org> <20071117104652.8240af62.akpm@linux-foundation.org> <20071117113501.5e3e0d43@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117113501.5e3e0d43@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> ok so how about putting the same into dump_stack() instead? (see 
> below) added bonus is that it's now present for all dumps that use 
> dump_stack(), not just WARN_ON() (the format I copied from the exact 
> line used by oopses)

nice! I did things like this in -rt because it really helps to know 
which process does a WARN_ON() or raw dump_stack().

> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

unless objections we'll put this into the x86 git tree.

	Ingo
