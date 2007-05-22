Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbXEVWuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbXEVWuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbXEVWuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:50:10 -0400
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:38036 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756332AbXEVWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:50:08 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Date: Wed, 23 May 2007 08:50:01 +1000
User-Agent: KMail/1.9.5
Cc: Ash Milsted <thatistosayiseenem@gawab.com>, linux-kernel@vger.kernel.org
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <200705222037.54741.kernel@kolivas.org> <20070522214222.8b197247.thatistosayiseenem@gawab.com>
In-Reply-To: <20070522214222.8b197247.thatistosayiseenem@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705230850.01844.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007 06:42, Ash Milsted wrote:
> Hi. I just did some video encoding on my desktop and I was noticing
> (for the first time in a while) that running apps had to hit swap quite
> a lot when I switched to them (the encoding was going at full blast for
> most of the day, and most of the time other running apps were
> idle). Now, a good half of my RAM appeared to be free during all this,
> so I was thinking at the time that it would be nice if swap prefetch
> could be tunably more aggressive. I guess it would be ideal in this
> case if it could kick in during tunably low disk-IO periods, even if
> the CPU is rather busy. I'm sure you've considered this, so I only butt
> in here to cast a vote for it. :)

In this case nicing the video encode should be enough to make it prefetch even 
during heavy cpu usage. It detects the total nice level rather than the cpu 
usage.

> Of course, I could be completely wrong about the possibility.. and I
> seem to remember that the disk cache can take up about half the ram by
> default without this showing up in 'gnome-system-monitor'... which I
> guess might happen during heavy encoding.. but even if it did, I could
> have set the limit lower, and would then have still appreciated
> prefetching.

I plan to make it prefetch more aggressively by default soon and make it more 
tunable too.

-- 
-ck
