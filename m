Return-Path: <linux-kernel-owner+w=401wt.eu-S1764354AbXF1DHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764354AbXF1DHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764023AbXF1DHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:07:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46831 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763768AbXF1DHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:07:08 -0400
Date: Thu, 28 Jun 2007 13:07:00 +1000
From: David Chinner <dgc@sgi.com>
To: mmarek@suse.cz
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] Fix XFS_IOC_*_TO_HANDLE and XFS_IOC_{OPEN,READLINK}_BY_HANDLE in compat mode
Message-ID: <20070628030700.GD989688@sgi.com>
References: <20070619132549.266927601@suse.cz> <20070619132726.627137347@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619132726.627137347@suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:25:51PM +0200, mmarek@suse.cz wrote:
> 32bit struct xfs_fsop_handlereq has different size and offsets (due to
> pointers). TODO: case XFS_IOC_{FSSETDM,ATTRLIST,ATTRMULTI}_BY_HANDLE
> still not handled.

Looks good. Added to my qa tree...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
