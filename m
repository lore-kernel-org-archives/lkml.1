Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbYBHRuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbYBHRuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762659AbYBHRtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:49:50 -0500
Received: from gecko.sbs.de ([194.138.37.40]:21839 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762604AbYBHRts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:49:48 -0500
Message-ID: <47AC95FC.5090701@siemens.com>
Date: Fri, 08 Feb 2008 18:48:44 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
References: <20080130011550.GA31853@elte.hu>	<200802050436.31070.maximlevitsky@gmail.com>	<alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <p73ejbn2xk2.fsf@bingen.suse.de>
In-Reply-To: <p73ejbn2xk2.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> kgdb? Not so interesting. We have many more hard problems happening at 
>> user sites, not in developer hands.
> 
> The other problem with the current kgdb code is that it has some serious
> problems. e.g. it reinvents various kernel interfaces that already
> exist -- one example is that it adds new notify_die()s just to reimplement
> the standard __ex_table exceptions in a bogus way.

/me was once wondering as well why kgdb installs a seconds way of
handling (its own) faults. Jason explained to me that this approach is
more robust against corruption along the normal fix-up path. Maybe he
can elaborate better than I why this is useful (or what real-life bug
once encouraged the current design).

> Couple of other issues. So even if it was a good idea to merge the
> code is not really fully in merge shape anyways.

If you recall the issues (and they are still present), it would be nice
to have them listed. kgdb suffered a lot from historic cruft, but we
already remove at least some of it over the last patching rounds.
Whatever remains should be addressed ASAP.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
