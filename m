Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbYD0MOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbYD0MOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYD0MOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:14:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbYD0MOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:14:16 -0400
Date: Sun, 27 Apr 2008 14:13:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: airlied@gmail.com, steve@xemacs.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: CONFIG_OPTIMIZE_INLINING
Message-ID: <20080427121357.GA9305@elte.hu>
References: <20080426.230807.144232984.davem@davemloft.net> <ed10ee420804270210y219ac4dbne858906233ab9691@mail.gmail.com> <21d7e9970804270216rcaf2462v4ee6f34cf9f9aa45@mail.gmail.com> <20080427.022130.193697611.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427.022130.193697611.davem@davemloft.net>
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

> From: "Dave Airlie" <airlied@gmail.com>
> Date: Sun, 27 Apr 2008 19:16:31 +1000
> 
> > just because something lands in the core kernel tree doesn't mean it 
> > is actually perfect, far from it..
> 
> This is entirely missing the point.
> 
> We get patches reviewed before they hit the tree, not afterwards.
> 
> Ingo is making that impossible.

hrmpf. David, i can only repeat that what you say is plain out false. 
The CONFIG_OPTIMIZE_INLINING patch was posted to lkml originally, about 
two months ago:

  http://lkml.org/lkml/2008/3/3/122
 
then it was re-posted at the time of the pull request as well:

  http://www.gossamer-threads.com/lists/linux/kernel/911104?page=last

and i just posted a (trivial) RFC patch to lkml today that would turn it 
into a generic feature:

  http://lkml.org/lkml/2008/4/27/47

so i'm not sure what this big fuss is about ...

Moving this (now apparently hotly desired!) feature from 
arch/x86/Kconfig to init/Kconfig is no big deal and lets continue with 
more important issues. No puppies got hurt, really :)

You can use the patch i posted or you've got my conceptual Acked-by for 
touching arch/x86/Kconfig or can do it without asking - i dont mind -, 
it's an obviously correct change that i not only wanted all along but 
also implemented that way originally (twice!), until stupid lkml 
objections forced it into arch/x86 as i went the path of least 
resistance.

Yes, in hindsight, i should have stood up for that change and should 
have made a stink about it on linux-arch but there's just so many 
flamewars that fit into a day ;-)

	Ingo
