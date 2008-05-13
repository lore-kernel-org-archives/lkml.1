Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbYEMKLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbYEMKLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYEMKLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:11:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46335 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYEMKLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:11:43 -0400
Date: Tue, 13 May 2008 12:11:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 0 of 8] x86: use PTE_MASK consistently
Message-ID: <20080513101125.GA32299@elte.hu>
References: <patchbomb.1210330958@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1210330958@localhost>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Here's a series to rationalize the use of PTE_MASK and remove some 
> amount of ad-hocery.
> 
> This gist of the series is:
>  1. Fix the definition of PTE_MASK so that its equally applicable in
>     all pagetable modes
>  2. Use it consistently
> 
> I haven't tried to address the *_bad() stuff, other than to convert 
> pmd_bad_* to use PTE_MASK.
> 
> I've compile tested it a bit and run it on 32-bit PAE (native and 
> Xen), but I haven't tested it with >4G memory, non-PAE or 64-bit.  In 
> other words, it needs some time in Ingo's torture machine.

applied, thanks. This patchset has held up fine so far in overnight 
testing, nice work.

	Ingo
