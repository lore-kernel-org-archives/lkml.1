Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYFVWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYFVWyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbYFVWyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:54:00 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:60812 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032AbYFVWx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:53:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABdyXkh5LG+u/2dsb2JhbACtTA
X-IronPort-AV: E=Sophos;i="4.27,686,1204464600"; 
   d="scan'208";a="132512119"
Date: Mon, 23 Jun 2008 08:53:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080622225355.GD11558@disturbed>
Mail-Followup-To: Miquel van Smoorenburg <mikevs@xs4all.net>,
	Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	xfs-masters@oss.sgi.com
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed> <20080620052716.GA2022@anita>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620052716.GA2022@anita>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 07:27:17AM +0200, Konstantin Kletschke wrote:
> Am 2008-06-13 13:08 +1000 schrieb Dave Chinner:
> 
> > This commit in 2.6.26 will probably fix it.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3
> 
> If I am correct, this fix is included in 2.6.26-rc6:

Yes, so if you're seeing it again then there's a different problem.

Please provide a pointer to a xfs_metadump image of the filesystem
and the steps to reproduce the error from the image so we can
get to the bottom of it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
