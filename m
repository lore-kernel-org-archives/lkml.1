Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbZHRMOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbZHRMOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZHRMOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:14:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44126 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZHRMOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:14:16 -0400
Date: Tue, 18 Aug 2009 14:13:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, akpm@linux-foundation.org,
       nhorman@tuxdriver.com, rostedt@goodmis.org
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
	enabled
Message-ID: <20090818121352.GA20286@elte.hu>
References: <4A89BF90.5070202@oracle.com> <20090817.160041.40869355.davem@davemloft.net> <20090817230654.GC16222@elte.hu> <20090817.170337.139340805.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817.170337.139340805.davem@davemloft.net>
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
> Date: Tue, 18 Aug 2009 01:06:54 +0200
> 
> > ... but these are the wrong patches, they should be removed or 
> > reverted and redone properly.
> 
> Given the number of users of net-next-2.6, removal via rebasing 
> is simply not an option.  The other two posibilities, sure...
> 
> > It's not just about keeping kernel/trace/* changes in the 
> > tracing tree (which we can relax on-demand given agreement), 
> > it's that these patches are also _wrong_ and we cannot relax 
> > anything about that.
> 
> Why don't we give Neil a chance to review the situation and fix 
> things up?
> 
> If revert is the final decision, that's fine, I'll revert 
> everything.
> 
> But in the mean time at least give Neil a chance to read all of 
> your feedback and coordinate a way to fix things with everyone.

Oh, sure. Conversion to TRACE_EVENT() is equivalent to the revert 
of the current patches plus introduction of the TRACE_EVENT() 
defines.

	Ingo
