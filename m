Return-Path: <linux-kernel-owner+w=401wt.eu-S935645AbYBHRSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935645AbYBHRSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934562AbYBHRAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:00:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187AbYBHRAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:00:15 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
From: Andi Kleen <andi@firstfloor.org>
References: <20080130011550.GA31853@elte.hu>
	<200802050436.31070.maximlevitsky@gmail.com>
	<alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
Date: Fri, 08 Feb 2008 18:00:13 +0100
In-Reply-To: <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> (Linus Torvalds's message of "Mon\, 4 Feb 2008 19\:27\:53 -0800 \(PST\)")
Message-ID: <p73ejbn2xk2.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> So I'd merge a patch that puts oops information (or the whole console 
> printout) in the Intel management stuff in a heartbeat. That code is 
> likely much grottier than any kgdb thing will ever be (Intel really 
> screwed up the interface and made it some insane XML thing), but it's also 
> fundamentally more important - if it means that normal users can give oops 
> reports after they happened in X (or, these days, probably more commonly 
> during suspend/resume) and the machine just died.

I agree. Even with XML ugliness that's a fairly important area.

> kgdb? Not so interesting. We have many more hard problems happening at 
> user sites, not in developer hands.

The other problem with the current kgdb code is that it has some serious
problems. e.g. it reinvents various kernel interfaces that already
exist -- one example is that it adds new notify_die()s just to reimplement
the standard __ex_table exceptions in a bogus way.
Couple of other issues. So even if it was a good idea to merge the
code is not really fully in merge shape anyways.

-Andi
