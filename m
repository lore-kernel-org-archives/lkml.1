Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab0APGiQ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 01:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240Ab0APGiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 01:38:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46205 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab0APGiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 01:38:15 -0500
Date: Sat, 16 Jan 2010 07:37:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [patch] kbuild: improve version string logic
Message-ID: <20100116063754.GC20342@elte.hu>
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com>
 <4B4345AF.9040600@suse.cz>
 <alpine.DEB.2.00.1001131300360.26527@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001131300360.26527@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> The LOCALVERSION= string passed to "make" will now always be appended to the 
> kernel version after CONFIG_LOCALVERSION, if it exists, regardless of 
> whether CONFIG_LOCALVERSION_AUTO is set or not.  This allows users to 
> uniquely identify their kernel builds with a string.

I've been using Linus's earlier patch for 3 months meanwhile in -tip and the 
'+' version string differentiator is very useful in practice. Your version of 
the patch should address some of the observations offered in the original 
discussion as well. Would be nice to have your patch upstream (in the next 
merge window or so).

Given that Sam doesnt maintain the kbuild tree anymore, would this patch be a 
good fit for -mm perhaps?

	Ingo
