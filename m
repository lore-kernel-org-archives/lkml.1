Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbZCHQAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbZCHQAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZCHQAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:00:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57153 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZCHQAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:00:23 -0400
Date: Sun, 8 Mar 2009 17:00:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu_barrier VS cpu_hotplug: Ensure callbacks in dead
	cpu are migrated to online cpu
Message-ID: <20090308160005.GE19658@elte.hu>
References: <49B2526E.40106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B2526E.40106@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> [RFC]
> I don't like this patch, but I thought for some days and I can't
> thought out a better one.

Interesting find. Found via code review or via testing? If via 
testing, what is the symptom of the bug when it hits - did you 
see CPU hotplug stress-tests hanging? Crashing too perhaps? How 
frequently did it occur?

It also appears we introduced this bug at around 2.6.26 (when 
the CPU hotplug code was rewritten) - or had it before that as 
well.

We are late in -rc's so i'm trying to scope whether it's a 
2.6.29 must-have or can wait for 2.6.30.

	Ingo
