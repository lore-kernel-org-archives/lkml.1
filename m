Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZAKMNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZAKMNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZAKMNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:13:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZAKMNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:13:37 -0500
Date: Sun, 11 Jan 2009 13:13:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, travis@sgi.com,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: cpumask change causes sparc build bustage
Message-ID: <20090111121315.GE27796@elte.hu>
References: <20090111.003103.39502700.davem@davemloft.net> <20090111205008.db0a410e.sfr@canb.auug.org.au> <20090111.040640.188129980.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111.040640.188129980.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Sun, 11 Jan 2009 20:50:08 +1100
> 
> > On Sun, 11 Jan 2009 00:31:03 -0800 (PST) David Miller <davem@davemloft.net> wrote:
> > >
> > > I'm surprised linux-next builds didn't catch this.
> > 
> > So am I.  http://kisskb.ellerman.id.au/kisskb/compiler/5/ shows my latest
> > builds of both linux-next and Linus' tree are OK for defconfig and
> > allnoconfig (allmodconfig fails for a different reason).
> > 
> > What is different about the failing config (compiler)?  Are there other
> > configs it would be sensible to build test?
> 
> Maybe you don't have NUMA enabled in the test build configs.
> I hit it during an allmodconfig.
> 
> Anyways this fixes it, someone please apply:
> 
> sparc64: Fix cpumask related build failure.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

applied it to tip/core/urgent and will send it to Linus later today. 
Thanks David!

	Ingo
