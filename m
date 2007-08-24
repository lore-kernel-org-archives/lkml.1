Return-Path: <linux-kernel-owner+w=401wt.eu-S1765505AbXHXJPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765505AbXHXJPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXHXJPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:15:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbXHXJPf (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:15:35 -0400
Date: Fri, 24 Aug 2007 11:15:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: RT Users List <linux-rt-users@vger.kernel.org>,
       LKML <Linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RT] - rebalance_domains incorrect parameter
Message-ID: <20070824091533.GA31142@elte.hu>
References: <1187946562.16573.47.camel@sx.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187946562.16573.47.camel@sx.thebigcorporation.com>
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


* Sven-Thorsten Dietrich <sven@thebigcorporation.com> wrote:

> Same issue has been fixed in mainline by: 
> 
> diff-tree de0cf899bbf06b6f64a5dce9c59d74c41b6b4232 (from
> 5d2b3d3695a841231b65b55
> Author: Oleg Nesterov <oleg@tv-sign.ru>
> Date:   Sun Aug 12 18:08:19 2007 +0200

> signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>

ah, you mean we should pick up an upstream fix for -rt? We'll do that 
and we'll pick up much more: all the other ~100 CFS commits that 
happened meanwhile. (Btw., there's no need to sign off on patch 
forwarding or backport requests - the signoff made me first believe this 
is some new patch.)

	Ingo
