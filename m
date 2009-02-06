Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZBFOuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZBFOuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbZBFOuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:50:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59795 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZBFOuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:50:07 -0500
Date: Fri, 6 Feb 2009 15:49:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>,
       "David S. Miller" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: [PATCH] forcedeth: make msi-x different name for rx-tx
Message-ID: <20090206144948.GD18368@elte.hu>
References: <498BC3A8.9040203@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498BC3A8.9040203@kernel.org>
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


Cool cleanups!

Would you mind to also fix the following - on all my systems that have 
forcedeth gigabit ethernet i've been getting these bogus warnings for 
_years_, under moderate load:

  eth2: too many iterations (16) in nv_nic_irq.

I think a 64 iterations limit will work much better. (i tried a limit of 50 
a year ago for a while and it worked fine and had no side effects - and the 
bogus warnings were done.)

	Ingo

