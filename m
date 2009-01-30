Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbZA3AaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbZA3AaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbZA3A37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:29:59 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:16744 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237AbZA3A36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:29:58 -0500
Date: Thu, 29 Jan 2009 16:28:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, torvalds <torvalds@linux-foundation.org>,
       Bill Nottingham <notting@redhat.com>, Ted Tso <tytso@mit.edu>
Subject: [PATCH 4/4] Documentation/Changes: add required versions for new
 filesystems
Message-Id: <20090129162840.adabb469.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.498249BC.006B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Bill Nottingham <notting@redhat.com>
Subject: [PATCH] Documentation/Changes: add required versions for new filesystems

btrfs requires version 0.18 of its tools, and squashfs requires 4.0.
ext3 should use and ext4 requires v1.41.4 of e2fsprogs.

Signed-off-by: Bill Nottingham <notting@redhat.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Ted Tso <tytso@mit.edu>
---
 Documentation/Changes |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20090126.orig/Documentation/Changes
+++ linux-next-20090126/Documentation/Changes
@@ -33,10 +33,12 @@ o  Gnu make               3.79.1        
 o  binutils               2.12                    # ld -v
 o  util-linux             2.10o                   # fdformat --version
 o  module-init-tools      0.9.10                  # depmod -V
-o  e2fsprogs              1.29                    # tune2fs
+o  e2fsprogs              1.41.4                  # e2fsck -V
 o  jfsutils               1.1.3                   # fsck.jfs -V
 o  reiserfsprogs          3.6.3                   # reiserfsck -V 2>&1|grep reiserfsprogs
 o  xfsprogs               2.6.0                   # xfs_db -V
+o  squashfs-tools         4.0                     # mksquashfs -version
+o  btrfs-progs            0.18                    # btrfsck
 o  pcmciautils            004                     # pccardctl -V
 o  quota-tools            3.09                    # quota -V
 o  PPP                    2.4.0                   # pppd --version
