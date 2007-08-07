Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXHGIAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXHGIAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXHGIAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:00:05 -0400
Received: from sargon.lncsa.com ([212.99.8.251]:58106 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbXHGIAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:00:04 -0400
Message-ID: <46B81440.4030402@lncsa.com>
Date: Tue, 07 Aug 2007 08:42:08 +0200
From: Laurent CARON <lcaron@lncsa.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Oops on 2.6.21 + DRBD + XFS
References: <20070806093449.aebaisai@trusted.lncsa.com> <20070806233122.GW31489@sgi.com> <20070807005848.GA13793@infradead.org>
In-Reply-To: <20070807005848.GA13793@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Aug 07, 2007 at 09:31:22AM +1000, David Chinner wrote:
>> On Mon, Aug 06, 2007 at 09:38:19AM +0200, Laurent Caron wrote:
>>> Hi,
>>>
>>> I'm using an XFS filesystem over DRBD for a few weeks on this machine
>>> and did experience an oops.
>> ......
>>> Aug  3 10:59:47 fileserv kernel: [<c0164be9>] cache_flusharray+0x59/0xd0 
>>> Aug  3 10:59:47 fileserv kernel: [<c0164d2a>] kmem_cache_free+0x5a/0x70 
>>> Aug  3 10:59:47 fileserv kernel: [<c025fa16>] xfs_finish_reclaim+0x36/0x170 
>>> Aug  3 10:59:47 fileserv kernel: [<c026fe41>] xfs_fs_clear_inode+0x91/0xc0 
>>> Aug  3 10:59:47 fileserv kernel: [<c017c063>] clear_inode+0x93/0x140 
>>> Aug  3 10:59:47 fileserv kernel: [<c017c38a>] dispose_list+0x1a/0xd0 
>> Can you run with slab debugging turned on?
> 
> And please upgrade to a recent kernel.  I'm pretty sure drbd doesn't
> like the useage of slab memory for bios in older xfs versions.
> 

I upgraded to 2.6.22.

We'll see if it improves.

Thanks
