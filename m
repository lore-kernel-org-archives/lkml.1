Return-Path: <linux-kernel-owner+w=401wt.eu-S934426AbXJRT30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbXJRT30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbXJRT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:29:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51093 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011AbXJRT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:29:16 -0400
Date: Thu, 18 Oct 2007 21:28:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mark Lord <lkml@rtr.ca>
Subject: Re: libata crash
Message-ID: <20071018192839.GA17247@elte.hu>
References: <20071018164745.GD10674@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018164745.GD10674@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> Hi Ingo,
> 
> Can you try this rolled up patch against current -git and see if it 
> works for you?

update: booted up a couple of times with your patch (with 
DEBUG_PAGEALLOC enabled) and it's working all fine, no crashes. So i 
think you nailed it!

	Ingo
