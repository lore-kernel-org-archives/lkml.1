Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbXCPJaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbXCPJaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXCPJaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:30:19 -0400
Received: from relay4.usu.ru ([194.226.235.39]:59552 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713AbXCPJaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:30:17 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 05:30:17 EDT
Message-ID: <45FA6148.4010504@ums.usu.ru>
Date: Fri, 16 Mar 2007 14:20:08 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: bunk@stusta.de
Subject: [PATCH][TRIVIAL] Remove obsolete fat_cvf help text
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The text removed by the following patch refers to functionality that 
never worked, to non-existing documentation file, and to mount options 
marked as obsolete in the module.

Signed-off-by: Alexander E. Patrakov


--- linux/fs/Kconfig	2007-02-20 11:34:32.000000000 +0500
+++ linux/fs/Kconfig	2007-03-16 14:07:09.000000000 +0500
@@ -731,10 +731,6 @@
 	  file system and use GNU tar's M option. GNU tar is a program
 	  available for Unix and DOS ("man tar" or "info tar").
 
-	  It is now also becoming possible to read and write compressed FAT
-	  file systems; read <file:Documentation/filesystems/fat_cvf.txt> for
-	  details.
-
 	  The FAT support will enlarge your kernel by about 37 KB. If unsure,
 	  say Y.
 

-- 
Alexander E. Patrakov

