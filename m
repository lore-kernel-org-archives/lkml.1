Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229Ab0ALAJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0ALAJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193Ab0ALAJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:09:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60736 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0ALAJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:09:42 -0500
Date: Tue, 12 Jan 2010 11:09:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20100112110939.234a6e65.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
Documentation/ioctl/ioctl-number.txt between commit
cb5a8b2c92febbed57126e1b8416dfd7607ff03d ("docs: large update to
ioctl-number.txt") from Linus' tree and commit
8f4e91dee2a245e4be6942f4a8d83a769e13a47d ("ceph: ioctls") from the ceph
tree.

Just overlapping additions - not a big deal.  I fixed it up (see below)
and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/ioctl/ioctl-number.txt
index 35cf64d,91cfdd7..0000000
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@@ -289,9 -181,8 +289,10 @@@ Code  Seq#(hex)	Include File		Comment
  0x8C	00-3F				WiNRADiO driver
  					<http://www.proximity.com.au/~brian/winradio/>
  0x90	00	drivers/cdrom/sbpcd.h
 +0x92	00-0F	drivers/usb/mon/mon_bin.c
  0x93	60-7F	linux/auto_fs.h
 +0x94	all	fs/btrfs/ioctl.h
+ 0x97    00-7F   fs/ceph/ioctl.h         Ceph file system
  0x99	00-0F				537-Addinboard driver
  					<mailto:buk@buks.ipn.de>
  0xA0	all	linux/sdp/sdp.h		Industrial Device Project
