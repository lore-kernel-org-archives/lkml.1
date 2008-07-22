Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbYGVKhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbYGVKhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYGVKgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:36:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbYGVKgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:36:48 -0400
Date: Tue, 22 Jul 2008 12:36:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080722103632.GA27029@elte.hu>
References: <20080716142225.GA19054@elte.hu> <20080722123231.GA13172@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722123231.GA13172@localhost.localdomain>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Wed, Jul 16, 2008 at 4:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> I'm not sure how we should proceed with this. On one hand, we could
> >> just fix the issues as they come up and be done with it. On the other
> >> hand, this was exactly the thing I wanted to avoid by automatic it. I
> >> guess it can never be fully automated... The question is if there is
> >> any danger of *silent* (read: runtime) breakage, which would be much
> >> worse than compiler errors.
> >
> > dont worry, lets fix the above hideous hack first, then i can merge the
> > guards fixes ontop of that fix. That's why we do testing, to catch the
> > cases where assumptions fail. Your script is just fine - it beats having
> > to edit 280+ files by hand ...
> 
> I've updated my script to also fix any rogue uses of header-guard 
> names in auxiliary files. I'm attaching the resulting patch.
> 
> It doesn't really _fix_ the hideous hack, it merely unbreaks it.
> 
> Patch #2 also fixes some left-over headers. They both apply on top of 
> tip/x86/header-guards.

looks good - do you have a branch i could pull into 
tip/x86/header-guards?

	Ingo
