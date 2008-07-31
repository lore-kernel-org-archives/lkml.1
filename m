Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYGaQkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYGaQkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYGaQkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:40:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41324 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYGaQkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:40:04 -0400
Date: Thu, 31 Jul 2008 18:39:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
Message-ID: <20080731163943.GF26393@elte.hu>
References: <20080728.161318.38361710.davem@davemloft.net> <20080728235133.GA7956@elte.hu> <20080728.174415.154327359.davem@davemloft.net> <20080729.214503.126934382.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729.214503.126934382.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> lockdep: Fix combinatorial explosion in lock subgraph traversal.

applied to tip/core/locking - thanks David. I guess we need to test this 
a bit, the patch is far from simple :-)

	Ingo
