Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbXITHF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbXITHF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXITHFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:21 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:64799 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXITHFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=WYX9iMnhs/g7m2PtjGgnrDTB4iKpk1Z/nCOXqKypPYIjc4rTKw90hz5c6NZuUoWXvJUI3w9js4o2BDQqFPud6UynmbLq1R5UQqpJVPF70o7w74h/fgApMvjULJV3tMxSlFMVW3mZPXtBh+oZvP16IPYh4U9qq14Zn/y1lbaZZHw=
Subject: [PATCHSET 1/4] sysfs: misc updates
In-Reply-To: 
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:09 +0900
Message-Id: <11902719091692-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

There are four patchsets going out today, which are...

 PS-1 misc updates
 PS-2 allow suicide
 PS-3 divorce sysfs from kobject and driver model
 PS-4 implement new features - symlink name formatting, plugging, batch
      error handling

And this is PS-1.  This patchset is on top of
drivers/sysfs-rewrite-sysfs_move_dir-in-terms-of-sysfs-dirents.patch
in gregkh-2.6 as of today (20070920, based on 2.6.23-rc6-git4) and
contains the following 15 patches.

 0001-sysfs-kill-SYSFS_FLAG_REMOVED.patch
 0002-sysfs-fix-comments-of-sysfs_add-remove_one.patch
 0003-sysfs-fix-sysfs_chmod_file-such-that-it-updates-s.patch
 0004-sysfs-clean-up-header-files.patch
 0005-sysfs-kill-sysfs_update_file.patch
 0006-sysfs-reposition-sysfs_dirent-s_mode.patch
 0007-sysfs-kill-unnecessary-sysfs_get-in-open-paths.patch
 0008-sysfs-kill-unnecessary-NULL-pointer-check-in-sysfs_.patch
 0009-sysfs-make-bin-attr-open-get-active-reference-of-pa.patch
 0010-sysfs-make-s_elem-an-anonymous-union.patch
 0011-sysfs-open-code-sysfs_attach_dentry.patch
 0012-sysfs-make-sysfs_root-a-regular-directory-dirent.patch
 0013-sysfs-move-sysfs_dirent-s_children-into-sysfs_dire.patch
 0014-sysfs-implement-sysfs_open_dirent.patch
 0015-sysfs-move-sysfs-file-poll-implementation-to-sysfs_.patch

0001 reverses earlier driver/sysfs-kill-sysfs_flag_removed.patch and
as such both patches can just be dropped.

0002-0003 contains misc fixes.  0004 reorganizes and cleans up sysfs
header files.  As these four patchsets are gonna disrupt out-of-tree
changes anyway, this is a good time to clean up.  0005-0013 are also
clean up patches.  They change and tune things here and there but
don't really cause behavior changes.

0014-0015 implements sysfs_open_dirent and moves poll implementation
to it.  This reduces the size of sysfs_dirent and fixes dangling
sleeper bug in the current poll implementation.

Thanks.

--
tejun


