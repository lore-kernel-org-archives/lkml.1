Return-Path: <linux-kernel-owner+w=401wt.eu-S966075AbXIKUdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966075AbXIKUdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbXIKUdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:33:41 -0400
Received: from lazybastard.de ([212.112.238.170]:48778 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177AbXIKUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:33:40 -0400
Date: Tue, 11 Sep 2007 22:29:43 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911202942.GB20688@lazybastard.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <Pine.LNX.4.64.0709111303590.25781@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0709111303590.25781@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 September 2007 13:07:06 -0700, Christoph Lameter wrote:
> 
> You may want to consider Mel's antifrag approaches which certainly 
> decreases the chance of this occurring. Reclaim can open up the needed 
> linear memory hole in a intentional way. The memory compaction approach 
> can even move pages to open up these 2M holes. The more pages we make 
> movable (see f.e. the targeted slab reclaim patchset that makes slab 
> pages movable) the more reliable higher order allocations become.

I absolutely agree with your slab reclaim patchset.  No argument here.

What I'm starting to wonder about is where your approach has advantages
over Andrea's.  The chances of triggering something vaguely similar to
Nick's worst case scenario are certainly higher for your solution.  So
unless there are other upsides it is just the second-best solution.

Jörn

-- 
Everything should be made as simple as possible, but not simpler.
-- Albert Einstein
