Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbXHSHPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbXHSHPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXHSHPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:15:14 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53640 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753403AbXHSHOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:14:49 -0400
Message-ID: <387507684.32383@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070819065349.160284305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 19 Aug 2007 14:53:49 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] dirty inode lists time delay/ordering fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Four bug fixes on the dirty inode lists :-)

They can be put immediately after the patch file named
writeback-fix-periodic-superblock-dirty-inode-flushing.patch:

[PATCH 1/6] writeback: fix time ordering of the per superblock inode lists 8
[PATCH 2/6] writeback: fix ntfs with sb_has_dirty_inodes()
[PATCH 3/6] writeback: remove pages_skipped accounting in __block_write_full_page()
[PATCH 4/6] writeback: introduce writeback_control.more_io to indicate more io

Also the check_dirty_inode_list.patch should be updated in place:
[PATCH 5/6] check dirty inode list

And this one is required to avoid warnings from the above debug patch:
[PATCH 6/6] prevent time-ordering warnings

Although not yet tested in highly parallel write workloads, I'm pretty sure
that the time ordering bug is gone :)

Thank you,
Fengguang
-- 
