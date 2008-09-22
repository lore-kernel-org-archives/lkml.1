Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYIVRnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYIVRnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYIVRnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:43:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58874 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIVRne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:43:34 -0400
Date: Mon, 22 Sep 2008 19:43:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: a.p.zijlstra@chello.nl, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: fix list traversal to use _rcu variant
Message-ID: <20080922174322.GA10535@elte.hu>
References: <48D7D081.8060807@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D7D081.8060807@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0019]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> From: Chris Friesen    <cfriesen@nortel.com>
>
> load_balance_fair() calls rcu_read_lock() but then traverses the list
> using the regular list traversal routine.  This patch converts the
> list traversal to use the _rcu version.
>
> Signed-off-by: Chris Friesen <cfriesen@nortel.com>
> Approval token "Nortel-02-July-2008-01"
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>

applied to tip/sched/devel, thanks Chris!

	Ingo
