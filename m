Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbXGKLwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbXGKLwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbXGKLw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:52:28 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:51231 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbXGKLw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:52:26 -0400
Date: Wed, 11 Jul 2007 05:52:24 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Christoph Hellwig <hch@infradead.org>, Mingming Cao <cmm@us.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Message-ID: <20070711115224.GT6417@schatzie.adilger.int>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
References: <1183275465.4010.130.camel@localhost.localdomain> <20070711084737.GA17675@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711084737.GA17675@infradead.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 11, 2007  09:47 +0100, Christoph Hellwig wrote:
> On Sun, Jul 01, 2007 at 03:37:45AM -0400, Mingming Cao wrote:
> > This patch is on top of i_version_update_vfs.
> > The i_version field of the inode is set on inode creation and incremented
> > when the inode is being modified.
> 
> Which is not what i_version is supposed to do.  It'll get you tons of misses
> for NFSv3 filehandles that rely on the generation staying the same for the
> same file.  Please add a new field for the NFSv4 sequence counter instead
> of making i_version unuseable.

You are confusing i_generation (the instance of this inode number) with
i_version (whether this file has been modified)?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

