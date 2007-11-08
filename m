Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXKIABr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXKIABr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 19:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763419AbXKIABk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 19:01:40 -0500
Received: from waste.org ([66.93.16.53]:50169 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762591AbXKIABj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 19:01:39 -0500
Date: Thu, 8 Nov 2007 17:08:41 -0600
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/23] SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
Message-ID: <20071108230841.GZ19691@waste.org>
References: <20071107011130.382244340@sgi.com> <20071107011226.844437184@sgi.com> <20071108145044.GB2591@skynet.ie> <20071108172548.GW17536@waste.org> <Pine.LNX.4.64.0711081116060.9279@schroedinger.engr.sgi.com> <20071108194735.GW19691@waste.org> <Pine.LNX.4.64.0711081159120.9966@schroedinger.engr.sgi.com> <20071108210348.GX19691@waste.org> <Pine.LNX.4.64.0711081328121.10596@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711081328121.10596@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 01:28:31PM -0800, Christoph Lameter wrote:
> On Thu, 8 Nov 2007, Matt Mackall wrote:
> 
> > But perhaps I should just add a lightweight RNG to random.c and be
> > done with it.
> 
> It would be appreciated.

As someone pointed out privately, there's a random32() in lib/random32.c.

Unfortunately, this function is too heavy for many fast-path uses and
too weak for most other uses. I'll see if I can come up with something
better..

-- 
Mathematics is the supreme nostalgia of our time.
