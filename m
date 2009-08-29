Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbZH2HfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbZH2HfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 03:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZH2HfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 03:35:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZH2HfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 03:35:08 -0400
Date: Sat, 29 Aug 2009 09:34:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/11] SFI: Simple Firmware Interface - v3
Message-ID: <20090829073455.GA27559@elte.hu>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org> <20090817100628.GA21498@elte.hu> <alpine.LFD.2.00.0908281949560.27023@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908281949560.27023@localhost.localdomain>
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


* Len Brown <lenb@kernel.org> wrote:

> 
> > Ok, this iteration is even nicer.
> 
> Thank you, Ingo, both for the thoughtful review,
> and your kind words.
> 
> >   Reviewed-by: Ingo Molnar <mingo@elte.hu>
> > 
> > A patch technical request/suggestion. I guess you'd like to keep 
> > these bits in the ACPI tree, so that you can test it and merge it 
> > with ongoing ACPI changes, right?
> > 
> > That would be fine to me for all the arch/x86/ touching patches, 
> > except for this one:
> > 
> >  [PATCH 05/11] ACPI, x86: expose some IO-APIC routines when CONFIG_ACPI=n
> > 
> > I'd like to pick this one up into tip:x86/apic, because there's 
> > ongoing work in this area. (also, by the looks of it, i'd not be 
> > surprised if this patch needed some testing. This is fragile code 
> > with quirky Kconfig dependencies.)
> > 
> > I can create a standalone topic for this (based on .31-rc6), 
> > containing this single commit, which you could pull into the ACPI 
> > tree? That way we both can have this commit and nobody is held up, 
> > and both trees can be pushed to Linus in the .32 merge window, 
> > independently of each other.
> 
> Sure.
> 
> Go ahead and pull that patch onto an 2.6.31-rc8 based branch from here:
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git for-ingo
> 
> As the previous patches did not depend on it, I simply rebased 
> that one to rc8 and moved the other patches after it.

Pulled, thanks Len!

	Ingo
