Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbZCTSng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbZCTSng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbZCTSn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:43:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42101 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZCTSn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:43:26 -0400
Date: Fri, 20 Mar 2009 19:43:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: mpparse cleanup
Message-ID: <20090320184311.GB4024@elte.hu>
References: <1237314836.3212.10.camel@localhost.localdomain> <1237380351.3042.0.camel@ht.satnam> <20090318141115.GA23034@elte.hu> <1237392355.12866.2.camel@ht.satnam> <20090318161829.GC21331@elte.hu> <1237536134.2494.5.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237536134.2494.5.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Wed, 2009-03-18 at 17:18 +0100, Ingo Molnar wrote:
> 
> > Looks good - pulled, thanks Jaswinder!
> > 
> > Would you be interested in resurrecting the more mechanic cleanups 
> > you did as well, on top of this patch?
> > 
> > They are still valuable, we just have to keep them separate from a 
> > potential breakage-causing change like the above one, so that if a 
> > tester bisects to it, we have an as single-purpose and focused 
> > commit to look at as possible.
> > 
> 
> cleanup without code change: based on tip:x86/core or x86/cleanups
> or .. ?
> 
> cleanup with code change: based on tip:x86/core or x86/cleanups or .. ?

Any of the x86/* branches is fine - they are permanent branches. 
(tip:master gets reintegrated every week or so)

x86/core would be the best choice.

	Ingo
