Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbZHQXHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbZHQXHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZHQXHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:07:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZHQXHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:07:11 -0400
Date: Tue, 18 Aug 2009 01:06:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, akpm@linux-foundation.org,
       nhorman@tuxdriver.com, rostedt@goodmis.org
Subject: Re: [PATCH -next] trace_skb: fix build when CONFIG_NET is not
	enabled
Message-ID: <20090817230654.GC16222@elte.hu>
References: <4A89BF90.5070202@oracle.com> <20090817.160041.40869355.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817.160041.40869355.davem@davemloft.net>
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

> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Mon, 17 Aug 2009 13:37:36 -0700
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix trace_skb_sources build when CONFIG_NET is not enabled:
> > 
> > kernel/built-in.o: In function `probe_skb_dequeue':
> > trace_skb_sources.c:(.text+0xd9152): undefined reference to `init_net'
> > trace_skb_sources.c:(.text+0xd9188): undefined reference to `dev_get_by_index'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Applied, thanks Randy.

... but these are the wrong patches, they should be removed or 
reverted and redone properly.

It's not just about keeping kernel/trace/* changes in the tracing 
tree (which we can relax on-demand given agreement), it's that 
these patches are also _wrong_ and we cannot relax anything about 
that.

	Ingo
