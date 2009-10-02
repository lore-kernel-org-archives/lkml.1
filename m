Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbZJBN02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbZJBN02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbZJBN01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:26:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757818AbZJBN01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:26:27 -0400
Date: Fri, 2 Oct 2009 15:26:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: mce: Please revert
	22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20091002132621.GA26275@elte.hu>
References: <20090930214859.GA28638@elte.hu> <20090930223956.GE17712@liondog.tnic> <20090930230947.GA9346@elte.hu> <20091001141432.GA11410@aftab> <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain> <20091001144637.GB11410@aftab> <20091001150046.GA21476@elte.hu> <20091001152140.GC11410@aftab> <20091001153250.GA25885@elte.hu> <20091002132101.GA28682@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002132101.GA28682@aftab>
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


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> On Thu, Oct 01, 2009 at 05:32:50PM +0200, Ingo Molnar wrote:
> > Yeah, that would be good. It should also obviously depend on 
> > CONFIG_X86_MCE - so only visible if MCE support is enabled.
> 
> Ok, here are the patches with the discussed changes added. By the way, 
> do we want that lot in .32 still or should I queue them up for the 
> merge window next year :) ?

I think it might be fine for this window still. The edac-mce angle is 
new code in this cycle and we want to fix it. I'll test it and we'll 
see.

	Ingo
