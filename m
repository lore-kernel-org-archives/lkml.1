Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbZFOMwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbZFOMwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbZFOMwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:52:37 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:31535 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219AbZFOMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:52:36 -0400
X-Trace: 215090863/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.113.131/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.113.131
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnECAAvhNUpPRXGD/2dsb2JhbAAI03qEDQU
X-IronPort-AV: E=Sophos;i="4.42,222,1243810800"; 
   d="scan'208";a="215090863"
Date: Mon, 15 Jun 2009 13:51:43 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
In-Reply-To: <20090615042753.GA20788@localhost>
Message-ID: <Pine.LNX.4.64.0906151341160.25162@sister.anvils>
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com>
 <20090615042753.GA20788@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Wu Fengguang wrote:
> On Mon, Jun 15, 2009 at 11:18:18AM +0800, Balbir Singh wrote:
> > Wu Fengguang wrote:
> > > 
> > > I hope we can reach consensus in this round and then be able to post
> > > a final version for .31 inclusion.
> > 
> > Isn't that too aggressive? .31 is already in the merge window.
> 
> Yes, a bit aggressive. This is a new feature that involves complex logics.
> However it is basically a no-op when there are no memory errors,
> and when memory corruption does occur, it's better to (possibly) panic
> in this code than to panic unconditionally in the absence of this
> feature (as said by Rik).
> 
> So IMHO it's OK for .31 as long as we agree on the user interfaces,
> ie. /proc/sys/vm/memory_failure_early_kill and the hwpoison uevent.
> 
> It comes a long way through numerous reviews, and I believe all the
> important issues and concerns have been addressed. Nick, Rik, Hugh,
> Ingo, ... what are your opinions?

And for how long has this work been in linux-next or mmotm?

My opinion is that it's way too late for .31 - your only chance
is that Linus sometimes gets bored with playing safe, and decides
to break his rules and try something out regardless - but I'd hope
the bootmem business already sated his appetite for danger this time.

Hugh
