Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbXHFXbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbXHFXbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932880AbXHFXbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:31:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47339 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932819AbXHFXbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:31:31 -0400
Date: Tue, 7 Aug 2007 09:31:22 +1000
From: David Chinner <dgc@sgi.com>
To: Laurent Caron <lcaron@lncsa.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops on 2.6.21 + DRBD + XFS
Message-ID: <20070806233122.GW31489@sgi.com>
References: <20070806093449.aebaisai@trusted.lncsa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806093449.aebaisai@trusted.lncsa.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 09:38:19AM +0200, Laurent Caron wrote:
> Hi,
> 
> I'm using an XFS filesystem over DRBD for a few weeks on this machine
> and did experience an oops.

......
> Aug  3 10:59:47 fileserv kernel: [<c0164be9>] cache_flusharray+0x59/0xd0 
> Aug  3 10:59:47 fileserv kernel: [<c0164d2a>] kmem_cache_free+0x5a/0x70 
> Aug  3 10:59:47 fileserv kernel: [<c025fa16>] xfs_finish_reclaim+0x36/0x170 
> Aug  3 10:59:47 fileserv kernel: [<c026fe41>] xfs_fs_clear_inode+0x91/0xc0 
> Aug  3 10:59:47 fileserv kernel: [<c017c063>] clear_inode+0x93/0x140 
> Aug  3 10:59:47 fileserv kernel: [<c017c38a>] dispose_list+0x1a/0xd0 

Can you run with slab debugging turned on?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
