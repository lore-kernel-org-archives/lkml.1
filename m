Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYJTLcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYJTLcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYJTLb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:31:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYJTLb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:31:56 -0400
Date: Mon, 20 Oct 2008 13:31:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
Message-ID: <20081020113143.GB14097@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org> <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop> <20081020090502.GB31710@elte.hu> <20081020110018.GA24579@elte.hu> <1224501352.7654.141.camel@pasglop> <1224501768.7654.144.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224501768.7654.144.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> > Still not too happy with the pointer thing but that's the best we 
> > can do I suppose without losing gcc type checking.
> 
> Oh, and I didn't like having the brackets around something that isn't 
> a range too but that's a minor details.

it looked quite natural in printouts to me, but no strong feelings.

	Ingo
