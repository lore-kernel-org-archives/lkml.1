Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYBJWcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYBJWcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYBJWcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:32:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39152 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYBJWcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:32:10 -0500
Date: Sun, 10 Feb 2008 23:31:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [patch] kgdb light, v6
Message-ID: <20080210223142.GA17571@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210093128.GA11350@infradead.org> <20080210171742.GF7088@elte.hu> <200802102155.46505.bzolnier@gmail.com> <20080210210900.GA27162@elte.hu> <47AF707C.6050305@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AF707C.6050305@web.de>
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


* Jan Kiszka <jan.kiszka@web.de> wrote:

> Ingo Molnar wrote:
> > * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >>> +static int init_kgdboc(void)
> >> __init
> > 
> > done.
> 
> Uuh, careful. We need this for runtime reconfiguration.

i think v7 is fine.

worst-case we'll get a nice fat section warning :-)

	Ingo
