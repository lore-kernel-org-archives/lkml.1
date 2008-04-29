Return-Path: <linux-kernel-owner+w=401wt.eu-S932759AbYD2OW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbYD2OW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765857AbYD2OVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:21:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765845AbYD2OVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:21:03 -0400
Date: Tue, 29 Apr 2008 16:20:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
       harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops: remove "optimizations"
Message-ID: <20080429142039.GD26461@elte.hu>
References: <alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804291141580.3261@apollo.tec.linutronix.de> <20080429.030332.88897602.davem@davemloft.net> <20080429.053412.15412725.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429.053412.15412725.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Tue, 29 Apr 2008 03:03:32 -0700 (PDT)
> 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Tue, 29 Apr 2008 12:01:02 +0200 (CEST)
> > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Acked-by: David S. Miller <davem@davemloft.net>
> 
> Ironically, I just bisected sparc64 bootup failures to the following 
> changeset.  It's very late here, and I haven't looked into the 
> details, but it seems to wedge in free_area_init_nodes() on a non-NUMA 
> system with CONFIG_NUMA disabled.

hm. I guess the next thing you plan to check is whether Thomas's patch 
fixes it?

> Isn't it funny that this optimization not only was useless, but also 
> broke things. :-/

yeah and sorry :-/ It would still be nice to understand why this 
happened, it looks like a weird (and unexpected) interaction.

	Ingo
