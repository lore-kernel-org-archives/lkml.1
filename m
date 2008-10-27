Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbYJ0RIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYJ0RIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYJ0RIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:08:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:36692 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYJ0RIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BVFeyuueMviOP2GhWXdaDvoL/jK2dweehMNZRRIG96SVXamdQbJZ+cHHiYXn9o41LS
         nSbHI+CaJlIJQx0NhyysyBIBtp547bWcTTguuNuNcj6Pz1/HKNfCA8YEVfWWlRIvjkk8
         V7uV0gDBSKXo42KOp/5qHgv6KMZDXyUdP8rtM=
Date: Mon, 27 Oct 2008 17:07:37 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-nfs@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: fs/nfs_common/Makefile: fix the C file name
Message-ID: <20081027170737.GA1027@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There's no file named 'nfs_acl.c' in that directory, it is 'nfsacl.c'.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: J. Bruce Fields <bfields@fieldses.org>

---
diff --git a/fs/nfs_common/Makefile b/fs/nfs_common/Makefile
index f689ed8..5cb60c5 100644
--- a/fs/nfs_common/Makefile
+++ b/fs/nfs_common/Makefile
@@ -2,6 +2,6 @@
 # Makefile for Linux filesystem routines that are shared by client and server.
 #
 
-obj-$(CONFIG_NFS_ACL_SUPPORT) += nfs_acl.o
+obj-$(CONFIG_NFS_ACL_SUPPORT) += nfsacl.o
 
 nfs_acl-objs := nfsacl.o

