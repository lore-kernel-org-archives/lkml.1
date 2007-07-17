Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbXGQJVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbXGQJVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXGQJVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:21:05 -0400
Received: from mx2.go2.pl ([193.17.41.42]:60324 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750732AbXGQJVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:21:04 -0400
Date: Tue, 17 Jul 2007 11:29:58 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Olaf Kirch <olaf.kirch@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717092958.GB2049@ff.dom.local>
References: <20070716091236.GA10718@elte.hu> <20070717061458.GB1640@ff.dom.local> <200707170955.38536.olaf.kirch@oracle.com> <200707171028.36451.olaf.kirch@oracle.com> <20070717085748.GA32114@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717085748.GA32114@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 10:57:48AM +0200, Ingo Molnar wrote:
> 
> Olaf,
> 
> i've got a new observation: changing CONFIG_HZ from 250 to 1000 makes 
> the problem go away. So it's somehow also related to jiffies.

IMHO it could be related with __LINK_STATE_RX_SCHED beeing set
too long e.g. between two softirqs. So, it could be really
a matter of timing out - not necessarily permanent error state.

Jarek P.
