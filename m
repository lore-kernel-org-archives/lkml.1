Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYH0H3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYH0H3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYH0H3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:29:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYH0H3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:29:01 -0400
Date: Wed, 27 Aug 2008 09:28:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] rcuclassic: fix compiler warning
Message-ID: <20080827072842.GB12191@elte.hu>
References: <48A9EC09.4060701@ct.jp.nec.com> <20080818232830.GG6732@linux.vnet.ibm.com> <48B4523E.70501@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B4523E.70501@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Paul E. McKenney wrote:
> > On Mon, Aug 18, 2008 at 02:39:21PM -0700, Hiroshi Shimamoto wrote:
> >> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >>
> >>   CC      kernel/rcuclassic.o
> >> kernel/rcuclassic.c: In function 'rcu_init_percpu_data':
> >> kernel/rcuclassic.c:705: warning: comparison of distinct pointer types lacks a cast
> >> kernel/rcuclassic.c:713: warning: comparison of distinct pointer types lacks a cast
> >>
> >> flags should be unsigned long.
> > 
> > You beat me to it!
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Hi Ingo, could you please apply this?

hm, the fix got lost due to a revert+reapply - i've applied your fix 
now, thanks for keeping an eye on it.

	Ingo
