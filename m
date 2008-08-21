Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYHUIkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYHUIkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYHUIjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:39:49 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:12355 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbYHUIjr (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:39:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAO/DrEh5LD0w/2dsb2JhbAC1XIFm
X-IronPort-AV: E=Sophos;i="4.32,244,1217773800"; 
   d="scan'208";a="176326760"
Date: Thu, 21 Aug 2008 18:39:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Message-ID: <20080821083916.GF5706@disturbed>
Mail-Followup-To: Jared Hulbert <jaredeh@gmail.com>,
	Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
	linux-mtd <linux-mtd@lists.infradead.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	tim.bird@AM.SONY.COM, cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00C4.6060302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD00C4.6060302@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 10:44:36PM -0700, Jared Hulbert wrote:
> I'd like to get a first round of review on my AXFS filesystem.  This is a simple
> read only compressed filesystem like Squashfs and cramfs.  AXFS is special
> because it also allows for execute-in-place of your applications.  It is a major
> improvement over the cramfs XIP patches that have been floating around for ages.
> The biggest improvement is in the way AXFS allows for each page to be XIP or
> not.  First, a user collects information about which pages are accessed on a
> compressed image for each mmap()ed region from /proc/axfs/volume0.  That
> 'profile' is used as an input to the image builder.  The resulting image has
> only the relevant pages uncompressed and XIP.  The result is smaller memory
> sizes and faster launches.

FWIW, I'm not sure it's a good idea to name this new filesystem AXFS.
People are almost certainly going to confuse it with XFS despite
the filesystems being aimed at diammetrically opposed ends of the
storage spectrum. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
