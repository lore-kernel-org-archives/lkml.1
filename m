Return-Path: <linux-kernel-owner+w=401wt.eu-S935070AbZJOI77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070AbZJOI77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935061AbZJOI77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:59:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55763 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935048AbZJOI76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:59:58 -0400
Date: Thu, 15 Oct 2009 10:59:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Message-ID: <20091015085905.GB10546@elte.hu>
References: <200910130004.46388.elendil@planet.nl> <20091013070505.GC31483@elte.hu> <200910131952.01209.elendil@planet.nl> <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain> <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com> <20091014065941.GH784@elte.hu> <alpine.DEB.1.00.0910140014490.26562@chino.kir.corp.google.com> <20091014073306.GB22778@elte.hu> <alpine.DEB.1.00.0910140037140.29264@chino.kir.corp.google.com> <alpine.DEB.1.00.0910150100590.10850@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0910150100590.10850@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> On Wed, 14 Oct 2009, David Rientjes wrote:
> 
> > We could easily go with my suggestion of allowing "make LOCALVERSION=" to 
> > override all additions to the kernel version when CONFIG_LOCALVERSION_AUTO 
> > is disabled.  For such configurations, kernels would be built with this 
> > variable to specify how it's different from the vanilla version and would 
> > suppress the `+'.
> > 
> 
> The following patch implements this suggestion and folds both of my 
> proposed patches together.

thanks David!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
