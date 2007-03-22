Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXCVMfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXCVMfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 08:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXCVMfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 08:35:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:4014 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXCVMfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 08:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=sr4HZ5lEG3M8fVuCTMeuk5pUQaiArTOpLPHuWRmOO+d9ANusoC2uMVKi9cfpErGZgO9bjjgkW/0s9+DARbqRhIDMP6p+YCly57uSIrXInIwgi7KKOIvkzrrf56OiHqXc58PdvTcCRh5aGEdAmDow/zOpriC/e0OkSz6PTuQbbUM=
Message-ID: <4602781C.9060804@gmail.com>
Date: Thu, 22 Mar 2007 15:35:40 +0300
From: Sergey Smirnov <svs1957@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: HELP!!! SD and suspend damage i-node.
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I use 2.6.20.2 kernel with ext3 rootfs on 4Gb SD on sharp zaurus sl-750 (PXA255).
After suspend/resume filesystem stay clean. But some i-nodes become broken.
Some files looks like block device or pipe with strange permissions, owner etc.
I'm sure that there is no bad blocks on SD.
I'll send any additional information. Just say me what you need to help me.
I had i lot of tries. Apply patches, remove its, change fstype etc.
output of fsck -f

e2fsck 1.40-WIP (14-Nov-2006)
Pass 1: Checking inodes, blocks, and sizes
Inode 328897 is in use, but has dtime set.  Fix<y>? yes

Inode 328897 has imagic flag set.  Clear<y>? yes

Deleted inode 328898 has zero dtime.  Fix<y>? yes

Inode 328901 is in use, but has dtime set.  Fix<y>? yes

Inode 328901 has imagic flag set.  Clear<y>? yes

Inode 328902 is in use, but has dtime set.  Fix<y>? yes

Inode 328902 has imagic flag set.  Clear<y>? yes

Inode 328903 is in use, but has dtime set.  Fix<y>? yes

Inode 328903 has imagic flag set.  Clear<y>? yes

Inode 328904 is in use, but has dtime set.  Fix<y>? yes

Inode 328904 has imagic flag set.  Clear<y>? yes

Inode 328905 is in use, but has dtime set.  Fix<y>? yes

Inode 328906 is in use, but has dtime set.  Fix<y>? yes

Inode 328907 is in use, but has dtime set.  Fix<y>? yes

Inode 328908 is in use, but has dtime set.  Fix<y>? yes

Inode 328897 has illegal block(s).  Clear<y>? yes

Illegal block #0 (4027835811) in inode 328897.  CLEARED.
Illegal block #1 (4293308792) in inode 328897.  CLEARED.
Illegal block #2 (55841555) in inode 328897.  CLEARED.
Illegal block #3 (2960401150) in inode 328897.  CLEARED.
Illegal block #4 (2197115429) in inode 328897.  CLEARED.
Illegal block #5 (4124718308) in inode 328897.  CLEARED.
Illegal block #6 (504504963) in inode 328897.  CLEARED.
Illegal block #7 (4028032370) in inode 328897.  CLEARED.
Illegal block #8 (4028097955) in inode 328897.  CLEARED.
Illegal block #9 (4001625378) in inode 328897.  CLEARED.
Illegal block #10 (1422192624) in inode 328897.  CLEARED.
Too many illegal blocks in inode 328897.
Clear inode<y>? yes

Inode 328907 has illegal block(s).  Clear<y>? yes

Illegal block #0 (880856325) in inode 328907.  CLEARED.
Illegal block #1 (3138519423) in inode 328907.  CLEARED.
Illegal block #2 (303682281) in inode 328907.  CLEARED.
Illegal block #3 (351229189) in inode 328907.  CLEARED.
Illegal block #4 (168967413) in inode 328907.  CLEARED.
Illegal block #5 (920785427) in inode 328907.  CLEARED.
Illegal block #6 (2733646821) in inode 328907.  CLEARED.
Illegal block #7 (607380579) in inode 328907.  CLEARED.
Illegal block #8 (3833787818) in inode 328907.  CLEARED.
Illegal block #9 (2213926708) in inode 328907.  CLEARED.
Illegal block #10 (2431648992) in inode 328907.  CLEARED.
Too many illegal blocks in inode 328907.
Clear inode<y>? yes

Inode 328904 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 328904, i_size is 1298022311761903630, should be 0.  Fix<y>? yes

Inode 328904, i_blocks is 17109592, should be 0.  Fix<y>? yes

Inode 328903 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 328903 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 328903, i_size is 4634368754045078648, should be 0.  Fix<y>? yes

Inode 328903, i_blocks is 33775633, should be 0.  Fix<y>? yes

Inode 328902 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 328902, i_size is 17719074603564334822, should be 0.  Fix<y>? yes

Inode 328902, i_blocks is 1342215186, should be 0.  Fix<y>? yes

Inode 328908 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 328908, i_size is 266945914413200612, should be 0.  Fix<y>? yes

Inode 328908, i_blocks is 3792889567, should be 0.  Fix<y>? yes

Inode 328906, i_size is 17222592312736442656, should be 0.  Fix<y>? yes

Inode 328906, i_blocks is 55615200, should be 0.  Fix<y>? yes

Inode 328901 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 328901, i_size is 367595204451501376, should be 0.  Fix<y>? yes

Inode 328901, i_blocks is 4293787104, should be 0.  Fix<y>? yes

Inode 328905 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 328905 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 328905, i_size is 8427850164134760656, should be 0.  Fix<y>? yes

Inode 328905, i_blocks is 58744799, should be 0.  Fix<y>? yes

Inodes thInode 328905, i_blocks is 58744799, should be 0.  Fix<y>? yes

Inodes that were part of a corrupted orphan linked list found.  Fix<y>? yes

Inode 474215 was part of the orphaned inode list.  FIXED.
Inode 474216 was part of the orphaned inode list.  FIXED.
Inode 474217 was part of the orphaned inode list.  FIXED.
Inode 474218 was part of the orphaned inode list.  FIXED.
Restarting e2fsck from the beginning...
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
at were part of a corrupted orphan linked list found.  Fix<y>? yes
Entry 'GMT+7' in /usr/share/zoneinfo/Etc (328890) has deleted/unused inode 328897.  Clear<y>? yes

Entry 'GMT-4' in /usr/share/zoneinfo/Etc (328890) has deleted/unused inode 328898.  Clear<y>? yes

Entry 'GMT-6' in /usr/share/zoneinfo/Etc (328890) has deleted/unused inode 328899.  Clear<y>? yes

Entry 'GMT+12' in /usr/share/zoneinfo/Etc (328890) has deleted/unused inode 328900.  Clear<y>? yes

i_file_acl for inode 328901 (/usr/share/zoneinfo/Etc/GMT+8) is 1474433559, should be zero.
Clear<y>? yes

Inode 328901 (/usr/share/zoneinfo/Etc/GMT+8) has invalid mode (0150002).
Clear<y>? yes

i_file_acl for inode 328902 (/usr/share/zoneinfo/Etc/GMT-9) is 1474433580, should be zero.
Clear<y>? yes

Inode 328902 (/usr/share/zoneinfo/Etc/GMT-9) is an illegal FIFO.
Clear<y>? yes

i_file_acl for inode 328903 (/usr/share/zoneinfo/Etc/GMT+3) is 1340408912, should be zero.
Clear<y>? yes

Inode 328903 (/usr/share/zoneinfo/Etc/GMT+3) is an illegal socket.
Clear<y>? yes
i_file_acl for inode 328904 (/usr/share/zoneinfo/Etc/GMT-11) is 3541173534, should be zero.
Clear<y>? yes

Inode 328904 (/usr/share/zoneinfo/Etc/GMT-11) has invalid mode (070460).
Clear<y>? yes

i_file_acl for inode 328905 (/usr/share/zoneinfo/Etc/GMT-2) is 3671200259, should be zero.
Clear<y>? yes

Inode 328905 (/usr/share/zoneinfo/Etc/GMT-2) has invalid mode (02402).
Clear<y>? yes

i_file_acl for inode 328906 (/usr/share/zoneinfo/Etc/GMT-14) is 1775436291, should be zero.
Clear<y>? yes

Inode 328906 (/usr/share/zoneinfo/Etc/GMT-14) has invalid mode (0160072).
Clear<y>? yes

Entry 'GMT-13' in /usr/share/zoneinfo/Etc (328890) has deleted/unused inode 328907.  Clear<y>? yes

i_file_acl for inode 328908 (/usr/share/zoneinfo/Etc/UTC) is 1627779327, should be zero.
Clear<y>? yes

i_faddr for inode 328908 (/usr/share/zoneinfo/Etc/UTC) is 1643504863, should be zero.
Clear<y>? yes

i_blocks_hi for inode 328908 (/usr/share/zoneinfo/Etc/UTC) is 34, should be zero.
Clear<y>? yes

Entry 'UTC' in /usr/share/zoneinfo/Etc (328890) has an incorrect filetype (was 1, should be 4).
Fix<y>? yes

Entry 'Universal' in /usr/share/zoneinfo/Etc (328890) has an incorrect filetype (was 1, should be 4).
Fix<y>? yes

Entry 'Zulu' in /usr/share/zoneinfo/Etc (328890) has an incorrect filetype (was 1, should be 4).
Fix<y>? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 328908 ref count is 36903, should be 3.  Fix<y>? yes

Pass 5: Checking group summary information
Block bitmap differences:  -(683136--683147)
Fix<y>? yes

Free blocks count wrong for group #20 (19709, counted=19721).
Fix<y>? yes

Free blocks count wrong (383277, counted=383289).
Fix<y>? yes

Inode bitmap differences:  -(328897--328900) -328907
Fix<y>? yes

Free inodes count wrong for group #20 (8392, counted=8397).
Fix<y>? yes

Free inodes count wrong (379610, counted=379615).
Fix<y>? yes


/dev/sdb1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sdb1: 110945/490560 files (0.1% non-contiguous), 597151/980440 blocks

