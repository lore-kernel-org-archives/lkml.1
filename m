Return-Path: <linux-kernel-owner+w=401wt.eu-S1763881AbYHEWil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763881AbYHEWil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761837AbYHEWiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:38:19 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60293 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761776AbYHEWiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:38:18 -0400
Date: Tue, 5 Aug 2008 18:36:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: trivial@kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Correct comment in identify_ramdisk_image() routine.
Message-ID: <alpine.LFD.1.10.0808051834090.19032@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct the comment to reflect that a gzipped image will return zero,
not -1.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

the code is correct, it's only the comment that's wrong.

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index fedef93..a7c748f 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -71,7 +71,7 @@ identify_ramdisk_image(int fd, int start_block)
 	sys_read(fd, buf, size);

 	/*
-	 * If it matches the gzip magic numbers, return -1
+	 * If it matches the gzip magic numbers, return 0
 	 */
 	if (buf[0] == 037 && ((buf[1] == 0213) || (buf[1] == 0236))) {
 		printk(KERN_NOTICE


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
