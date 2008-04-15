Return-Path: <linux-kernel-owner+w=401wt.eu-S1764749AbYDOUEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764749AbYDOUEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYDOUDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:03:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46691 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755100AbYDOUDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:03:51 -0400
Date: Tue, 15 Apr 2008 13:03:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <20080415195430.GA23015@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
References: <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
 <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
 <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
 <20080415062534.GA9172@elte.hu> <alpine.LFD.1.00.0804150838161.2879@woody.linux-foundation.org>
 <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Ingo Molnar wrote:

> Pretty please, could you pay more than cursory attention to this bug i 
> already spent two full days on and which is blocking the v2.6.25 
> release?

Yeah trying to get to understand how exactly sparsemem works and how the 
32 bit highmem stuff interacts with it... Sorry not code that I am an 
expert in nor the platform that I am familiar with. Code mods there 
required heavy review from multiple parties with expertise in various 
subjects.

> I'm just guessing my way around, but right now my impression is that the 
> current early memory setup code is unrobust, over-complex, occasionally 
> butt-ugly to read code in high need of cleanups, simplifications and 
> debug facilities, visibly plagued by hit-and-run changes with frequent 
> typos and everything else you normally dont want to see in the core 
> kernel. (Did i get your attention now? ;-)

I thought the NR_SECTIONS stuff would trigger some memories. Adding apw 
who seemed to be most familiar with the material in the past 
(AFAICT NODE_NOT_IN_PAGE_FLAGS is there for IBM NUMAQ etc) and Kame-san.

Andy, Kame-san could you have a look at the sparsemem config issue with 
32 bit !PAE? This is SPARSEMEM_STATIC.


