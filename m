Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbXGCVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbXGCVlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbXGCVlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:41:35 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:54584 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbXGCVle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:41:34 -0400
Date: Tue, 3 Jul 2007 15:41:31 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Message-ID: <20070703214131.GH6578@schatzie.adilger.int>
Mail-Followup-To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
References: <1183275465.4010.130.camel@localhost.localdomain> <4689F17C.7050304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4689F17C.7050304@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 03, 2007  12:19 +0530, Aneesh Kumar K.V wrote:
> Mingming Cao wrote:
> >Index: linux-2.6.22-rc4/fs/ext4/super.c
> >===================================================================
> >--- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-13 
> >17:19:11.000000000 -0700
> >+++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-13 17:24:45.000000000 -0700
> >@@ -2846,8 +2846,8 @@ out:
> > 		i_size_write(inode, off+len-towrite);
> > 		EXT4_I(inode)->i_disksize = inode->i_size;
> > 	}
> >-	inode->i_version++;
> > 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> >+	inode->i_version = 1;
> > 	ext4_mark_inode_dirty(handle, inode);
> > 	mutex_unlock(&inode->i_mutex);
> > 	return len - towrite;
> 
> 
> Is this correct ? . Why do we set the qutoa file inodes version to 1  
> during write ?

Hmm, I thought we had previously fixed this?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

