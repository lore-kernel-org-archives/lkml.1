Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYIJGiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYIJGiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYIJGiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:38:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33273 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYIJGiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:38:07 -0400
Date: Wed, 10 Sep 2008 08:37:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Doc/RCU: fix pseudocode in rcuref.txt
Message-ID: <20080910063745.GC14700@elte.hu>
References: <48C73873.1010708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C73873.1010708@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> atomic_inc_not_zero(v) return 0 if *v = 0.
> use spin_lock instead of write_lock for update lock.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

i've applied it to tip/core/rcu (unless Paul has objections) - thanks!

	Ingo
