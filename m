Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXHASEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXHASEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbXHASEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:04:06 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:58634 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760809AbXHASEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:04:04 -0400
Date: Wed, 1 Aug 2007 14:03:52 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070801180352.GA15061@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <Pine.LNX.4.64.0708011952280.26668@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011952280.26668@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 07:58:49PM +0200, Jan Engelhardt wrote:
> 
> On Jul 31 2007 12:36, Josef Sipek wrote:
> >[2] http://www.filesystems.org/unionfs-odf.txt
> 
> >Instead, the new ODF code stores whiteouts as hardlinks to a special
> >(regular) zero-length file in odf (/odf/whiteout), and it stores opaqueness
> >information for directories in the inode GID bits in an ODF file system
> >(e.g., ext2, XFS, etc.) on the local machine.  This avoids the name-space
> >pollution and avoids races with network file systems, while minimizing inode
> >consummation in /odf.
> 
> Inode GID bits - are you reducing my 32 bits of gid_t to 31 bits?
> That does not work out either.

No. The ODF code just uses the GID bits to store extra info. The GID is
_NOT_ used to store the GID of the file. The GID of the file is still coming
from the branches.

Josef 'Jeff' Sipek.

-- 
I abhor a system designed for the "user", if that word is a coded pejorative
meaning "stupid and unsophisticated."
		- Ken Thompson
