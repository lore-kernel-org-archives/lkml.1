Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbYFEOXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbYFEOXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYFEOXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:23:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522AbYFEOXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:23:08 -0400
Date: Thu, 5 Jun 2008 16:22:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: David Miller <davem@davemloft.net>, mcmanus@ducksong.com,
       peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, rjw@sisk.pl,
       Andrew Morton <akpm@linux-foundation.org>, johnpol@2ka.mipt.ru
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
	v2.6.26-rc3+
Message-ID: <20080605142244.GA19216@elte.hu>
References: <20080603094057.GA29480@elte.hu> <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi> <Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi> <20080603.150344.145518113.davem@davemloft.net> <Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi>
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


* Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:

> [PATCH] tcp DEFER_ACCEPT: fix racy access to listen_sk

i unapplied the reverts then applied your fix, and got this hang after 
1.5 hours of testing:

 titan:~> netstat -nt
 Active Internet connections (w/o servers)
 Proto Recv-Q Send-Q Local Address           Foreign Address   State
 tcp        0  65032 10.0.1.14:39454         10.0.1.19:3632    ESTABLISHED

10.0.1.14 is this box, Core2Duo dual-core. 10.0.1.19 is another box with 
16 CPUs.

	Ingo
