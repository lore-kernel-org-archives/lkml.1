Return-Path: <linux-kernel-owner+w=401wt.eu-S1946522AbXD3RmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946522AbXD3RmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946536AbXD3RmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:42:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60902 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946522AbXD3RmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:42:10 -0400
Date: Mon, 30 Apr 2007 10:42:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: vmstat: use our own timer events
In-Reply-To: <4635F938.3060706@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0704301041230.6343@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704282206530.29468@schroedinger.engr.sgi.com>
 <20070429011518.259448ba.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704292138480.1737@schroedinger.engr.sgi.com>
 <4635F938.3060706@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Arjan van de Ven wrote:

> > Well the cache_reaper of SLAB hits hard todays anyways. This will help
> > if they switch to slub because the counter consolidation is much lighter
> > weight.
> 
> it's not about the weight. It's about waking up *at all*. I've been working
> really hard to get a system with a reasonable average idle time (600ms+), but
> I obviously had to patch the SLAB reaper to be at a different resolution...

If you use SLUB then its going to be gone.

> > I am fine with delaying this. I just wanted the timer guys to have a chance
> > to shape this a bit. Not sure what they want. What they did to the
> > cache_reaper in 2.6.20/21 is bad.
> 
> HUH? The cache_reaper DID NOT CHANGE with the round_jiffies() change.
> Before it had a 3 jiffies per cpu offset, after it has a 3 jiffies per cpu
> offset.

It seems that it does use round_jiffies_relative() instead?
 
