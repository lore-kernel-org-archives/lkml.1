Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZCKLou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZCKLou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZCKLoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:44:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:31768 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbZCKLoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:44:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,342,1233561600"; 
   d="scan'208";a="119085729"
Date: Wed, 11 Mar 2009 19:43:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: jack marrow <jackmarrow2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Memory usage per memory zone
Message-ID: <20090311114353.GA759@localhost>
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi jack,

On Wed, Mar 11, 2009 at 11:41:43AM +0100, jack marrow wrote:
> Hello,
> 
> I have a box where the oom-killer is killing processes due to running
> out of memory in zone_normal. I can see using slabtop that the inode

How do you know that the memory pressure on zone normal stand out alone?

> caches are using up lots of memory and guess this is the problem, so
> have cleared them using an echo to drop_caches.

It would better be backed by concrete numbers...

> 
> I would quite like to not guess though - is it possible to use slabtop
> (or any other way) to view ram usage per zone so I can pick out the
> culprit?

/proc/zoneinfo and /proc/vmstat do have some per-zone numbers.
Some of them deal with slabs.

Thanks,
Fengguang

