Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYIOM4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYIOM4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 08:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYIOM4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 08:56:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45160 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYIOM4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 08:56:33 -0400
Date: Mon, 15 Sep 2008 14:56:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fmayhar@google.com, adobriyan@gmail.com, roland@redhat.com,
       tglx@linutronix.de
Subject: Re: + itimers-fix-itimer-many-thread-hang.patch added to -mm tree
Message-ID: <20080915125600.GE304@elte.hu>
References: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org> <20080914175040.GA819@tv-sign.ru> <20080914183932.GC28010@elte.hu> <20080915123432.GA199@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915123432.GA199@tv-sign.ru>
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


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 09/14, Ingo Molnar wrote:
> >
> > Oleg, the changes (with a few fixups from me) are in tip/master now
> 
> Great! This patch needs testing.

it has not caused any test failures so far.

> > (with a rough v2.6.28 target) - should i back them out for now, or 
> > do you think we can fix the items you noticed gradually?
> 
> Up to Frank and Roland, but I think we can make the cleanups 
> incrementally, on top of this patch.

ok. I'd prefer incremental, as the current stuff seems stable in 
practice.

	Ingo
