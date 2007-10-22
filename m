Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXJVJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXJVJ2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXJVJ2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:28:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34654 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbXJVJ2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:28:08 -0400
Date: Mon, 22 Oct 2007 11:27:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20071022092753.GA7659@elte.hu>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org> <20071015114738.6b5a25c7.akpm@linux-foundation.org> <20071015192822.GA2267@kernel.dk> <20071022091057.GB2781@elte.hu> <20071022022319.a5988afe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022022319.a5988afe.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > but what bothers me even more is the large picture. Linux's 
> > development is still fundamentally skewed towards bandwidth (which 
> > goes up with hardware advances anyway), while the focus on latencies 
> > is very lacking (which users do care about much more and which 
> > usually does _not_ improve with improved hardware), so i cannot see 
> > why we shouldnt apply this. Reminds me of the illogical, almost 
> > superstitious resistence against the relatime patch. (which is not 
> > in 2.6.24 mind you - killed for good)
> 
> Try `mount -o relatime' and prepare to be surprised ;)

i mean this one:

  http://people.redhat.com/mingo/relatime-patches/improve-relatime.patch

this actually makes relatime practical.

	Ingo
