Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYD0GAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYD0GAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 02:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYD0GAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 02:00:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbYD0GAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 02:00:12 -0400
Date: Sun, 27 Apr 2008 07:59:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, viro@ZenIV.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080427055943.GA16290@elte.hu>
References: <20080426.215513.141243565.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426.215513.141243565.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> Ingo, why the heck is this hiding under arch/x86/ and not in 
> lib/Kconfig.debug where it belongs?
> 
>     x86: add optimized inlining
> 
> If there are platforms that can't handle it, we can add a conditional 
> to lib/Kconfig.debug, but by default it should be made available 
> generically.
>
> Where did this original patch get posted for review and discussion?
> 
> Tell me where!?!?!

here, two months ago:

  http://lkml.org/lkml/2008/3/3/122

i made it x86-only due to this FUD that went against it:

  "messing with a global #define in a way that the results on 24 
   architectures with 7 different releases of gcc would be 
   unpredictable."

... as i saw no reason why this feature, which i found rather useful, 
should be delayed another year or so. I'd be more than happy to promote 
this feature back to lib/Kconfig.debug, sparc64 interest would make that 
a strong argument.

and here is the pull request that i posted to lkml, with the full patch 
included as well:

  http://www.gossamer-threads.com/lists/linux/kernel/911104?page=last

> The only references I see is where Stephen Rothwell complained that it 
> broke the powerpc build, and then on the git commit list when Linus 
> sucked this crud in.

i think there must something wrong about your lkml feed.

	Ingo
