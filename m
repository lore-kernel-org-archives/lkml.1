Return-Path: <linux-kernel-owner+w=401wt.eu-S1030735AbXCSXaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030735AbXCSXaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030739AbXCSXaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:30:18 -0400
Received: from hermes.domdv.de ([193.102.202.1]:4566 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030735AbXCSXaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:30:16 -0400
Message-ID: <45FF1D08.7000905@domdv.de>
Date: Tue, 20 Mar 2007 00:30:16 +0100
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       trond.myklebust@fys.uio.no
Subject: 2.6.20.3 NFS: BUG at fs/nfs/pagelist.c:339
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got this from a nfs booted 2.6.20.3 x86 system (complete diskless boot):

BUG: at fs/nfs/pagelist.c:339 nfs_scan_dirty()
 [<c017b1cc>] nfs_scan_dirty+0x17e/0x18a
 [<c013407a>] generic_writepages+0x224/0x2b6
 [<c017e116>] nfs_wait_on_requests_locked+0x80/0x8e
 [<c017f56f>] nfs_sync_mapping_wait+0x9d/0x14b
 [<c014d0df>] __link_path_walk+0x854/0x943
 [<c017f72e>] nfs_sync_mapping_range+0x97/0xb6
 [<c01783e2>] nfs_getattr+0x3a/0x96
 [<c01783a8>] nfs_getattr+0x0/0x96
 [<c014942a>] vfs_getattr+0x21/0x30
 [<c01494b2>] vfs_lstat_fd+0x2b/0x3d
 [<c0138684>] free_pgtables+0x7e/0x8a
 [<c0149a7f>] sys_lstat64+0xf/0x23
 [<c013b082>] remove_vma+0x36/0x3b
 [<c013c3c2>] remove_vma_list+0x40/0x4a
 [<c013c6d2>] do_munmap+0xf3/0xff
 [<c013c70e>] sys_munmap+0x30/0x35
 [<c0102b40>] syscall_call+0x7/0xb
-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
