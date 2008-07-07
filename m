Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYGGTTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYGGTTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbYGGTS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:18:57 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40988 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbYGGTS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:18:56 -0400
Date: Mon, 7 Jul 2008 15:18:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] FS: Label tmpfs Kconfig option with "tmpfs".
Message-ID: <alpine.LFD.1.10.0807071517090.29975@localhost.localdomain>
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


Make it clear that the Kconfig option refers to "tmpfs".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  if people haven't yet figured out that this used to be shm fs, they
probably don't need to know.


diff --git a/fs/Kconfig b/fs/Kconfig
index 2694648..9360b69 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -979,7 +979,7 @@ config SYSFS
 	Designers of embedded systems may wish to say N here to conserve space.

 config TMPFS
-	bool "Virtual memory file system support (former shm fs)"
+	bool "tmpfs support (Virtual memory file system)"
 	help
 	  Tmpfs is a file system which keeps all files in virtual memory.

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
