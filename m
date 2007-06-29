Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbXF2H0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbXF2H0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXF2H0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:26:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46304 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbXF2H0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:26:30 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [GIT PULL -mm] Unionfs cleanups and fixes
Date: Fri, 29 Jun 2007 03:26:16 -0400
Message-Id: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches consist of mostly cleanups and bug fixes of the
Unionfs code.

As before, there is a git repo at:

git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

(master.kernel.org:/pub/scm/linux/kernel/git/jsipek/unionfs.git)

There are 5 new commits:

Erez Zadok (4):
      Unionfs: Convert all instances of "hidden" to "lower"
      Unionfs: Use file->f_path instead of file->f_dentry
      Unionfs: Clarification comment for unionfs_lookup
      Unionfs: Remove unnecessary BUG_ON in unionfs_follow_link

Josef 'Jeff' Sipek (1):
      Unionfs: Add missing unlock call in unionfs_file_release

Thanks,

Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>

