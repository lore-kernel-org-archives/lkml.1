Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYGXJfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYGXJfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYGXJff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:35:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbYGXJfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:35:34 -0400
Date: Thu, 24 Jul 2008 11:34:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>
Subject: Re: [TCP bug, regression] stuck distcc connections in latest -git
Message-ID: <20080724093411.GA12001@elte.hu>
References: <20080724060448.GA10203@elte.hu> <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au> <20080724.022259.113079007.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724.022259.113079007.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> BTW, if someone can contact the Fedora folks, specifically whoever 
> added that syncookies enable to /etc/sysctl.conf, and let them know 
> that they've set our TCP stack back by 10 years by disabling SACK and 
> timestamps, I'd really appreciate it.

Server box (F9) has:

 # Controls the use of TCP syncookies
 net.ipv4.tcp_syncookies = 1

 timestamp of /etc/sysctl.conf: 2008-05-15, installation default i think.

Other (F8) box has:

 # Controls the use of TCP syncookies
 net.ipv4.tcp_syncookies = 0

 timestamp of /etc/sysctl.conf: 2007-01-28, touched 1.5 years ago.

Have not checked the install defaults - if i touched them it was a long 
time ago.

	Ingo
