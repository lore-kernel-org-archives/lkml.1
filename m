Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbXJBJDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbXJBJDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXJBJDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:03:05 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39058 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751788AbXJBJDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:03:00 -0400
Message-ID: <391315777.14430@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071002084143.110486039@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 02 Oct 2007 16:41:43 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Michael Rubin <mrubin@google.com>
Subject: [PATCH 0/5] sluggish writeback fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

The following patches fix the sluggish writeback behavior.
They are well understood and well tested - but not yet widely tested.

The first patch reverts the debugging -mm only check_dirty_inode_list.patch -
which is no longer necessary.

The following 4 patches do the real jobs:

[PATCH 2/5] writeback: fix time ordering of the per superblock inode lists 8
[PATCH 3/5] writeback: fix ntfs with sb_has_dirty_inodes()
[PATCH 4/5] writeback: remove pages_skipped accounting in __block_write_full_page()
[PATCH 5/5] writeback: introduce writeback_control.more_io to indicate more io

They share the same goal as the following patches in -mm. Therefore I'd
recommend to put the last 4 new ones after them:

writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-periodic-superblock-dirty-inode-flushing.patch

Regards,
Fengguang
--
