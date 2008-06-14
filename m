Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYFNG2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYFNG2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 02:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYFNG2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 02:28:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYFNG2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 02:28:12 -0400
Date: Sat, 14 Jun 2008 08:27:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT]: Networking
Message-ID: <20080614062758.GA23803@elte.hu>
References: <20080612.211959.52937006.davem@davemloft.net> <20080614060320.GA18454@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614060320.GA18454@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, that regression is not fully fixed yet - your revert differs from 
> the one i tested (from Ilpo) by the delta patch below. Without the 
> extra change below i got this net/sched/sch_generic.c warning, twice:
> 
> [  173.354049] NETDEV WATCHDOG: eth0: transmit timed out
> [  173.354148] ------------[ cut here ]------------
> [  173.354221] WARNING: at net/sched/sch_generic.c:222 dev_watchdog+0x9a/0xec()

just to clarify the bug pattern: the box was still accessible after the 
warning. So this is a far less serious problem and i'd suggest we open 
up a separate regression entry for it and consider the hung-TCP problem 
closed. (i havent seen the hang in the last week, with either version of 
the tcp-accept reverts)

	Ingo
