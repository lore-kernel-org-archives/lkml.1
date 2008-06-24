Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbYFXLiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbYFXLiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYFXLh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:37:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50609 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbYFXLh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:37:56 -0400
Date: Tue, 24 Jun 2008 13:37:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       josh@freedesktop.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent
	rcutorture less power-hungry
Message-ID: <20080624113710.GB21890@elte.hu>
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com> <20080622200638.GA25328@linux.vnet.ibm.com> <20080622131712.54ba732c@infradead.org> <20080622210255.GF22569@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622210255.GF22569@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > could you also make it use round_jiffies_relative() to make the 
> > power impact even less..... (by coalescing various "once a second" 
> > timers like this)
> 
> Good point!!!  As follows, on top of the previous one.
> 
> This patch aligns the rcutorture wakeup times to align with all other 
> multiple-of-a-second wakeups to further decrease power consumption.
> 
> Suggested-by: Arjan van de Ven <arjan@infradead.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

applied to tip/core/rcu - thanks Paul.

	Ingo
