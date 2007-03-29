Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbXC2NQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbXC2NQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXC2NQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:16:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:43647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbXC2NQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:16:56 -0400
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, william.morrow@amd.com,
       jordan.crouse@amd.com, Thomas Gleixner <tglx@linutronix.de>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org>
	<200703271816.33868.lenb@kernel.org>
	<200703272218.50531.lenb@kernel.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Mar 2007 16:15:28 +0200
In-Reply-To: <200703272218.50531.lenb@kernel.org>
Message-ID: <p73lkhg2l1b.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> On an Intel processor, it seems that the safe and simple route
> is if the system exports C2 or deeper, don't use the LAPIC timer.
> (which is what 2.6.21-rc5 is doing as of this moment)
> We may be able to white-list some systems over time.

On AMD it is the same, except that there seems to be at least
one system that does C2 like things while only exporting C1.
That is why i proposed to check for a battery too -- if there is one
always disable it too.

-Andi
