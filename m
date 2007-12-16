Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbXLPI66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbXLPI66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 03:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbXLPI6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 03:58:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54346 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbXLPI6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 03:58:46 -0500
Date: Sun, 16 Dec 2007 09:58:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Wang Chen <wangchen@cn.fujitsu.com>,
       Gerrit Renker <gerrit@erg.abdn.ac.uk>, davem@davemloft.net,
       andi@firstfloor.org, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 3/3] [UDP6]: Counter increment on BH mode
Message-ID: <20071216085818.GA27280@elte.hu>
References: <20071130111949.GB28277@gerrit.erg.abdn.ac.uk> <20071201015438.GC26895@gondor.apana.org.au> <4753AE07.1040906@cn.fujitsu.com> <20071203113935.GA25124@gondor.apana.org.au> <20071203114912.GA4425@ms2.inr.ac.ru> <20071203115435.GA4202@gondor.apana.org.au> <20071203131723.GA30312@gondor.apana.org.au> <20071215135851.GA29063@gondor.apana.org.au> <20071215184327.GA21434@elte.hu> <20071216023621.GB959@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216023621.GB959@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Sat, Dec 15, 2007 at 07:43:28PM +0100, Ingo Molnar wrote:
> >
> > we could perhaps introduce stat_smp_processor_id(), which signals that 
> > the CPU id is used for statistical purposes and does not have to be 
> > exact? In any case, your patch looks good too.
> 
> Unfortunately that doesn't work because we can then have two CPUs 
> trying to update the same counter which may corrupt it.

ah, indeed. I missed that correctness aspect of your patch. Good catch!

	Ingo
