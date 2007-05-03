Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbXECIco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbXECIco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXECIco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:32:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47342 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXECIcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:32:43 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 04:32:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG_ variables under fs/
Message-ID: <Pine.LNX.4.64.0705030430310.26812@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  there didn't seem to be enough output to justify posting this one
filesystem at a time, so here's the entire fs/ directory:

$ ../dead_config.sh fs
========== BEFS_RW ==========
fs/befs/linuxvfs.c:779:#ifndef CONFIG_BEFS_RW
fs/befs/linuxvfs.c:785:#endif                           /*
CONFIG_BEFS_RW */
========== CIFS_QUOTA ==========
fs/cifs/cifsfs.c:48:#ifdef CONFIG_CIFS_QUOTA
fs/cifs/cifsfs.c:123:#ifdef CONFIG_CIFS_QUOTA
fs/cifs/cifsfs.c:315:#ifdef CONFIG_CIFS_QUOTA
========== EXT3_INDEX ==========
fs/ext3/namei.c:147:#ifdef CONFIG_EXT3_INDEX
fs/ext3/namei.c:842:#ifdef CONFIG_EXT3_INDEX
fs/ext3/namei.c:930:#ifdef CONFIG_EXT3_INDEX
fs/ext3/namei.c:1083:#ifdef CONFIG_EXT3_INDEX
fs/ext3/namei.c:1299:#ifdef CONFIG_EXT3_INDEX
fs/ext3/namei.c:1399:#ifdef CONFIG_EXT3_INDEX
fs/ext3/namei.c:1409:#ifdef CONFIG_EXT3_INDEX
fs/ext3/namei.c:1428:#ifdef CONFIG_EXT3_INDEX
fs/ext3/namei.c:1444:#ifdef CONFIG_EXT3_INDEX
fs/ext3/dir.c:51:#ifdef CONFIG_EXT3_INDEX
fs/ext3/dir.c:111:#ifdef CONFIG_EXT3_INDEX
fs/ext3/dir.c:234:#ifdef CONFIG_EXT3_INDEX
========== EXT4_INDEX ==========
fs/ext4/namei.c:147:#ifdef CONFIG_EXT4_INDEX
fs/ext4/namei.c:840:#ifdef CONFIG_EXT4_INDEX
fs/ext4/namei.c:928:#ifdef CONFIG_EXT4_INDEX
fs/ext4/namei.c:1081:#ifdef CONFIG_EXT4_INDEX
fs/ext4/namei.c:1297:#ifdef CONFIG_EXT4_INDEX
fs/ext4/namei.c:1397:#ifdef CONFIG_EXT4_INDEX
fs/ext4/namei.c:1407:#ifdef CONFIG_EXT4_INDEX
fs/ext4/namei.c:1426:#ifdef CONFIG_EXT4_INDEX
fs/ext4/namei.c:1442:#ifdef CONFIG_EXT4_INDEX
fs/ext4/dir.c:51:#ifdef CONFIG_EXT4_INDEX
fs/ext4/dir.c:111:#ifdef CONFIG_EXT4_INDEX
fs/ext4/dir.c:234:#ifdef CONFIG_EXT4_INDEX
========== HAS_COMPAT_EPOLL_EVENT ==========
fs/compat.c:2242:#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
fs/compat.c:2285:#endif /* CONFIG_HAS_COMPAT_EPOLL_EVENT */
fs/compat.c:2312:#ifdef CONFIG_HAS_COMPAT_EPOLL_EVENT
========== NCPFS_DEBUGDENTRY ==========
fs/ncpfs/ncplib_kernel.c:729:#ifdef CONFIG_NCPFS_DEBUGDENTRY
========== XFS_DEBUG ==========
fs/xfs/xfs.h:21:#ifdef CONFIG_XFS_DEBUG
fs/xfs/Makefile-linux-2.6:23:ifeq ($(CONFIG_XFS_DEBUG),y)
========== XFS_DMAPI ==========
fs/xfs/linux-2.6/xfs_file.c:45:#ifdef CONFIG_XFS_DMAPI
fs/xfs/linux-2.6/xfs_file.c:247:#ifdef CONFIG_XFS_DMAPI
fs/xfs/linux-2.6/xfs_file.c:262:#endif /* CONFIG_XFS_DMAPI */
fs/xfs/linux-2.6/xfs_file.c:347:#ifdef CONFIG_XFS_DMAPI
fs/xfs/linux-2.6/xfs_file.c:350:#endif /* CONFIG_XFS_DMAPI */
fs/xfs/linux-2.6/xfs_file.c:400:#ifdef CONFIG_XFS_DMAPI
fs/xfs/linux-2.6/xfs_file.c:421:#endif /* CONFIG_XFS_DMAPI */
fs/xfs/linux-2.6/xfs_file.c:508:#ifdef CONFIG_XFS_DMAPI
fs/xfs/linux-2.6/xfs_file.c:516:#endif /* CONFIG_XFS_DMAPI */
fs/xfs/linux-2.6/xfs_super.h:21:#ifdef CONFIG_XFS_DMAPI
fs/xfs/linux-2.6/xfs_super.h:81:#ifdef CONFIG_XFS_DMAPI
========== XFS_TRACE ==========
fs/xfs/support/ktrace.h:50:#ifdef CONFIG_XFS_TRACE
fs/xfs/support/ktrace.h:85:#endif       /* CONFIG_XFS_TRACE */
fs/xfs/xfs.h:28:#ifdef CONFIG_XFS_TRACE
fs/xfs/Makefile-linux-2.6:94:xfs-$(CONFIG_XFS_TRACE)            += xfs_dir2_trace.o
fs/xfs/Makefile-linux-2.6:118:xfs-$(CONFIG_XFS_TRACE)           += support/ktrace.o
fs/xfs/linux-2.6/xfs_super.h:75:#ifdef CONFIG_XFS_TRACE

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
