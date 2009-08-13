Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZHMRpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZHMRpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZHMRpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:45:36 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:32720 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbZHMRpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:45:35 -0400
X-Trace: 245897141/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.105.228/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.105.228
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEADfug0pQKWnk/2dsb2JhbACBUtMzhBkF
X-IronPort-AV: E=Sophos;i="4.43,375,1246834800"; 
   d="scan'208";a="245897141"
Date: Thu, 13 Aug 2009 18:45:18 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] swap: send callback when swap slot is freed
In-Reply-To: <4A837AAF.4050103@vflare.org>
Message-ID: <Pine.LNX.4.64.0908131836270.14631@sister.anvils>
References: <200908122007.43522.ngupta@vflare.org>
 <Pine.LNX.4.64.0908122312380.25501@sister.anvils> <4A837AAF.4050103@vflare.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Nitin Gupta wrote:
> On 08/13/2009 04:18 AM, Hugh Dickins wrote:
> 
> > But fundamentally, though I can see how this cutdown communication
> > path is useful to compcache, I'd much rather deal with it by the more
> > general discard route if we can.
> 
> I tried this too -- make discard bio request as soon as a swap slot becomes
> free (I can send details if you want). However, I could not get it to work.

I'll send you an updated version of what I experimented with eight
months ago: but changes in the swap_map count handling since then
mean that it might need some subtle adjustments - I'll need to go
over it carefully and retest before sending you.

(But that won't be a waste of my time: I shall soon need to try
that experiment again myself, and I do need to examine those
intervening swap_map count changes more closely.)

> Also, allocating bio to issue discard I/O request looks like a complete
> artifact in compcache case.

Yes, I do understand that feeling.

Hugh
