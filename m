Return-Path: <linux-kernel-owner+w=401wt.eu-S1765725AbXHGA7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765725AbXHGA7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 20:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764321AbXHGA66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 20:58:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764214AbXHGA65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 20:58:57 -0400
Date: Tue, 7 Aug 2007 01:58:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Laurent Caron <lcaron@lncsa.fr>, linux-kernel@vger.kernel.org
Subject: Re: Oops on 2.6.21 + DRBD + XFS
Message-ID: <20070807005848.GA13793@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Chinner <dgc@sgi.com>, Laurent Caron <lcaron@lncsa.fr>,
	linux-kernel@vger.kernel.org
References: <20070806093449.aebaisai@trusted.lncsa.com> <20070806233122.GW31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806233122.GW31489@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 09:31:22AM +1000, David Chinner wrote:
> On Mon, Aug 06, 2007 at 09:38:19AM +0200, Laurent Caron wrote:
> > Hi,
> > 
> > I'm using an XFS filesystem over DRBD for a few weeks on this machine
> > and did experience an oops.
> 
> ......
> > Aug  3 10:59:47 fileserv kernel: [<c0164be9>] cache_flusharray+0x59/0xd0 
> > Aug  3 10:59:47 fileserv kernel: [<c0164d2a>] kmem_cache_free+0x5a/0x70 
> > Aug  3 10:59:47 fileserv kernel: [<c025fa16>] xfs_finish_reclaim+0x36/0x170 
> > Aug  3 10:59:47 fileserv kernel: [<c026fe41>] xfs_fs_clear_inode+0x91/0xc0 
> > Aug  3 10:59:47 fileserv kernel: [<c017c063>] clear_inode+0x93/0x140 
> > Aug  3 10:59:47 fileserv kernel: [<c017c38a>] dispose_list+0x1a/0xd0 
> 
> Can you run with slab debugging turned on?

And please upgrade to a recent kernel.  I'm pretty sure drbd doesn't
like the useage of slab memory for bios in older xfs versions.
