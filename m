Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZJLO1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZJLO1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbZJLO1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:27:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829AbZJLO1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:27:36 -0400
Date: Mon, 12 Oct 2009 16:26:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012142634.GB4565@elte.hu>
References: <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost> <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <20091012142714.56362465@marrow.netinsight.se> <20091012123210.GB22766@elte.hu> <20091012140821.5dfa1598@lxorguk.ukuu.org.uk> <20091012132503.GD25464@elte.hu> <1255354342.30919.17.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255354342.30919.17.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2009-10-12 at 15:25 +0200, Ingo Molnar wrote:
> > 
> > I care about this because i still havent given up hope that the 
> > company you are working for will finally give us some permanent 
> > storage in the CPU itself, so that we can have cross-reboot printk 
> > buffering ;-)
> 
> Why would it have to be in the CPU? If we had decent firmware, 
> couldn't we just look at the old kernel's log_buf in RAM?

Not if the failure is say a s2ram hang that requires a power cycle. Also 
there are certain classes of bugs that only occur on cold boot. Plus 
there's the "need to unplug the battery to revive the system" class of 
bugs (but they are rare).

So i think the MTD / flash stuff is powerful.

	Ingo
