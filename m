Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbXIOKxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbXIOKxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXIOKxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:53:02 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbXIOKxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:53:00 -0400
Date: Sat, 15 Sep 2007 03:52:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Message-Id: <20070915035228.8b8a7d6d.akpm@linux-foundation.org>
In-Reply-To: <1189850897.21778.301.camel@twins>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>
	<1189850897.21778.301.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 12:08:17 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2007-09-15 at 08:27 +0100, Anton Altaparmakov wrote:
> 
> Please, don't word wrap log-files, they're hard enough to read without
> it :-(
> 
> ( I see people do this more and more often, *WHY*? is that because we
> like 80 char lines, in code and email? )

Isn't it?

> 
> Anyway, looks like all of zone_normal is pinned in kernel allocations:
> 
> > Sep 13 15:31:25 escabot Normal free:3648kB min:3744kB low:4680kB high: 5616kB active:0kB inactive:3160kB present:894080kB pages_scanned:5336 all_unreclaimable? yes
> 
> Out of the 870 odd mb only 3 is on the lru.
> 
> Would be grand it you could have a look at slabinfo and the like.

Definitely.

> > Sep 13 15:31:25 escabot free:1090395 slab:198893 mapped:988  
> > pagetables:129 bounce:0

814,665,728 bytes of slab.
