Return-Path: <linux-kernel-owner+w=401wt.eu-S933494AbXGQI6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494AbXGQI6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762153AbXGQI6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:58:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761310AbXGQI6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:58:06 -0400
Date: Tue, 17 Jul 2007 10:57:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717085748.GA32114@elte.hu>
References: <20070716091236.GA10718@elte.hu> <20070717061458.GB1640@ff.dom.local> <200707170955.38536.olaf.kirch@oracle.com> <200707171028.36451.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707171028.36451.olaf.kirch@oracle.com>
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


Olaf,

i've got a new observation: changing CONFIG_HZ from 250 to 1000 makes 
the problem go away. So it's somehow also related to jiffies.

	Ingo
