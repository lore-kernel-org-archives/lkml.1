Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbXHFJYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbXHFJYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbXHFJYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:24:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41245 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760308AbXHFJYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:24:14 -0400
Date: Mon, 6 Aug 2007 11:24:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: check_irq_resend warning from pdc202xx_new
Message-ID: <20070806092405.GB30639@elte.hu>
References: <46B59892.7040504@simon.arlott.org.uk> <200708061113.26137.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708061113.26137.bzolnier@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> commit 0fc4969b866671dfe39b1a9119d0fdc7ea0f63e5
> 
> This report also doesn't seem to help with ne2k-pci problem...

no, it doesnt, and that wasnt the purpose of that WARN_ON_ONCE() - the 
purpose was to keep a temporary workaround ... temporary.

	Ingo
