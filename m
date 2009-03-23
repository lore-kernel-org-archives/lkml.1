Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZCWQdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZCWQdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZCWQc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:32:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758105AbZCWQcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:55 -0400
Date: Mon, 23 Mar 2009 09:23:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.29-rc8-git5: Reported regressions from 2.6.28
In-Reply-To: <20090323005738.GB6003@localhost>
Message-ID: <alpine.LFD.2.00.0903230922440.3030@localhost.localdomain>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera> <20090321200534.GA30238@elte.hu> <20090323005738.GB6003@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Mar 2009, Wu Fengguang wrote:
> > 
> > I think this was tracked back to the effective halving of 
> > dirty_ratio by 1cf6e7d83 ("mm: task dirty accounting fix") and 
> > doubling the ratio fixed the iozone regression.
> 
> Yes, exactly. The patch for fixing this regression is trivial.

I was planning on applying that patch only after 2.6.29 is out, and then 
if there are no surprising side effects and nobody complains, we'd then 
back-port it into stable.

		Linus
