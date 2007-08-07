Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbXHGHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbXHGHAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbXHGHAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:00:06 -0400
Received: from sargon.lncsa.com ([212.99.8.251]:45564 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbXHGHAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:00:04 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 03:00:04 EDT
Message-ID: <46B813F8.40709@lncsa.com>
Date: Tue, 07 Aug 2007 08:40:56 +0200
From: Laurent CARON <lcaron@lncsa.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Oops on 2.6.21 + DRBD + XFS
References: <20070806093449.aebaisai@trusted.lncsa.com> <20070806233122.GW31489@sgi.com>
In-Reply-To: <20070806233122.GW31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Mon, Aug 06, 2007 at 09:38:19AM +0200, Laurent Caron wrote:
>> Hi,
>>
>> I'm using an XFS filesystem over DRBD for a few weeks on this machine
>> and did experience an oops.
> 
> ......
>> Aug  3 10:59:47 fileserv kernel: [<c0164be9>] cache_flusharray+0x59/0xd0 
>> Aug  3 10:59:47 fileserv kernel: [<c0164d2a>] kmem_cache_free+0x5a/0x70 
>> Aug  3 10:59:47 fileserv kernel: [<c025fa16>] xfs_finish_reclaim+0x36/0x170 
>> Aug  3 10:59:47 fileserv kernel: [<c026fe41>] xfs_fs_clear_inode+0x91/0xc0 
>> Aug  3 10:59:47 fileserv kernel: [<c017c063>] clear_inode+0x93/0x140 
>> Aug  3 10:59:47 fileserv kernel: [<c017c38a>] dispose_list+0x1a/0xd0 
> 
> Can you run with slab debugging turned on?

I unfortunately can't play much with this machine since it is a
production server.
