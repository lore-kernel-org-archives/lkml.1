Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYF1X43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYF1X43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 19:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYF1X4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 19:56:22 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33725 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYF1X4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 19:56:21 -0400
Date: Sun, 29 Jun 2008 00:55:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Chris Wright <chrisw@sous-sol.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH trivial] security: remove unused forwards
Message-ID: <Pine.LNX.4.64.0806290054351.18327@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why would linux/security.h need forward declarations for nfsctl_arg
and swap_info_struct?  It's hard to imagine: remove them.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/security.h |    2 --
 1 file changed, 2 deletions(-)

--- linux-next/include/linux/security.h	2008-06-27 13:39:19.000000000 +0100
+++ linux/include/linux/security.h	2008-06-27 14:08:00.000000000 +0100
@@ -101,9 +101,7 @@ extern unsigned long mmap_min_addr;
 #define LSM_SETID_FS	8
 
 /* forward declares to avoid warnings */
-struct nfsctl_arg;
 struct sched_param;
-struct swap_info_struct;
 struct request_sock;
 
 /* bprm_apply_creds unsafe reasons */
