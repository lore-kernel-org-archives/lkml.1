Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbZHQXDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbZHQXDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbZHQXDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:03:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35744 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbZHQXDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:03:49 -0400
Date: Tue, 18 Aug 2009 01:03:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, akpm@linux-foundation.org,
       nhorman@tuxdriver.com, rostedt@goodmis.org
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
	enabled
Message-ID: <20090817230326.GB16222@elte.hu>
References: <20090817215808.GB15016@elte.hu> <20090817.153326.69833512.davem@davemloft.net> <20090817224727.GA13795@elte.hu> <20090817.155942.143261709.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817.155942.143261709.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 18 Aug 2009 00:47:27 +0200
> 
> > Also, has the review feedback from the tracing folks been 
> > addressed? Please separate these patches out and lets do this 
> > properly, this approach is not acceptable.
> 
> Fine, will keep you guys in the loop next time :-)

thanks

If the TRACE_EVENT() form is used then it can be done just fine 
from the networking tree too by enhancing 
include/trace/events/skb.h - TRACE_EVENT() is a decentralized 
facility.

We try not to add new ftrace plugins but extend the set of generic 
tracepoints.

	Ingo
