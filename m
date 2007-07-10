Return-Path: <linux-kernel-owner+w=401wt.eu-S1762421AbXGJUMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762421AbXGJUMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbXGJULy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:11:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53396 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXGJULw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:11:52 -0400
Date: Wed, 11 Jul 2007 01:42:00 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com
Subject: [PATCH 0/7][TAKE6] fallocate system call
Message-ID: <20070710201200.GA10255@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the latest fallocate patchset and is rebased to 2.6.22.

Following are the changes from TAKE5:
1) Rebased to 2.6.22
2) Added compat wrapper for x86_64
3) Dropped s390 and ia64 patches, since the platform maintaners can
   add the support for fallocate once it is in mainline.
4) Added a change suggested by Andreas for better extent-to-group
   alignment in ext4 (Patch 6/6). Please refer following post:
http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg02445.html
5) Renamed mode flags and values from "FA_" to "FALLOC_"
6) Added manpage (updated version of the one initially submitted by
   David Chinner).


Todos:
-----
1> Implementation on other architectures (other than i386, x86_64,
   and ppc64). s390(x) and ia64 patches are ready and will be pushed
   by platform maintaners when the fallocate is in mainline.
2> A generic file system operation to handle fallocate
   (generic_fallocate), for filesystems that do _not_ have the fallocate
   inode operation implemented.
3> Changes to glibc,
   a) to support fallocate() system call
   b) to make posix_fallocate() and posix_fallocate64() call fallocate()
4> A testcase to test the system call. Will post it soon.


Following patches follow:
Patch 1/7 : manpage for fallocate
Patch 2/7 : fallocate() implementation in i386, x86_64 and powerpc
Patch 3/7 : support new modes in fallocate
Patch 4/7 : ext4: fallocate support in ext4
Patch 5/7 : ext4: write support for preallocated blocks
Patch 6/7 : ext4: support new modes in ext4
Patch 7/7 : ext4: change for better extent-to-group alignment


--
Regards,
Amit Arora
