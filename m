Return-Path: <linux-kernel-owner+w=401wt.eu-S933772AbYBHSWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772AbYBHSWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYBHSWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:22:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38785 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759720AbYBHSWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:22:11 -0500
Date: Fri, 8 Feb 2008 19:57:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080208185719.GA11573@one.firstfloor.org>
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <p73ejbn2xk2.fsf@bingen.suse.de> <47AC95FC.5090701@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AC95FC.5090701@siemens.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /me was once wondering as well why kgdb installs a seconds way of
> handling (its own) faults. Jason explained to me that this approach is
> more robust against corruption along the normal fix-up path.

That's 100% bogus.

> 
> If you recall the issues (and they are still present), it would be nice
> to have them listed. kgdb suffered a lot from historic cruft, but we
> already remove at least some of it over the last patching rounds.
> Whatever remains should be addressed ASAP.

I sent Jason a couple of mails last time when he posted (and before that the
previous maintainer when he tried to merge it).   All were
fairly "beratungsresistent".

If you're truly interested i can dig out the mails or do a fresh review.

Long ago I did a quite clean x86-64 kgdb for Linux 2.4 based on the 
old 2.4 stub that dropped in without any strange other hooks
(except for a straight forward change to the serial code). It worked
just fine this way.

-Andi

