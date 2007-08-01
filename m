Return-Path: <linux-kernel-owner+w=401wt.eu-S1763933AbXHAR7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763933AbXHAR7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761320AbXHAR6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:58:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38029 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761586AbXHAR6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:58:51 -0400
Date: Wed, 1 Aug 2007 19:58:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
In-Reply-To: <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0708011952280.26668@fbirervta.pbzchgretzou.qr>
References: <20070730161323.100048969@weierstrass.suse.de>
 <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 31 2007 12:36, Josef Sipek wrote:
>[2] http://www.filesystems.org/unionfs-odf.txt

>Instead, the new ODF code stores whiteouts as hardlinks to a special
>(regular) zero-length file in odf (/odf/whiteout), and it stores opaqueness
>information for directories in the inode GID bits in an ODF file system
>(e.g., ext2, XFS, etc.) on the local machine.  This avoids the name-space
>pollution and avoids races with network file systems, while minimizing inode
>consummation in /odf.

Inode GID bits - are you reducing my 32 bits of gid_t to 31 bits?
That does not work out either.



	Jan
-- 
