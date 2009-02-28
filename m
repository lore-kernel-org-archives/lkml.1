Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZB1M6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZB1M6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 07:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZB1M6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 07:58:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZB1M6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 07:58:36 -0500
Date: Sat, 28 Feb 2009 13:58:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090228125816.GA14917@elte.hu>
References: <20090224020304.GA4496@google.com> <200902272305.01867.nickpiggin@yahoo.com.au> <20090228082922.GB11425@elte.hu> <200902282249.57479.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902282249.57479.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > It might be wrong on the principle though, so will revert it 
> > if needed, before it spreads into too many topics.
> 
> I would say if Linus didn't like it, revert it.
> 
> Do you use NFS with 1500 byte packets with a high speed 
> network and really fast disks (or ramdisk)? Then maybe you can 
> measure vectored write speedup with your patch over Salman's 
> more basic one :)

Can you suggest some other workload that should show sensitivity 
to this detail too? Like a simple write() loop of non-4K-sized 
files or so?

	Ingo
