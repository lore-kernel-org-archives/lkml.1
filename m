Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbZJLSIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbZJLSIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933032AbZJLSIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:08:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbZJLSIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:08:44 -0400
Date: Mon, 12 Oct 2009 20:07:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 0/4] DEBUG_RCU_HEAD: Debug and fix racy call_rcu() users
Message-ID: <20091012180739.GE17138@elte.hu>
References: <20091006143727.868480435@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006143727.868480435@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Here is a patchset, done on 2.6.30.9, which permits to detect and fix 
> racy call_rcu() users.

Nice idea - but any reason why this isnt using the debugojects 
framework? That debugging framework is upstream already and allows this 
kind of object lifetime debugging - in a much broader way.

	Ingo
