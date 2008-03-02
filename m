Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbYCBT0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbYCBT0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYCBT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:26:37 -0500
Received: from fallback0.mail.ox.ac.uk ([129.67.1.175]:46086 "EHLO
	fallback0.mail.ox.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYCBT0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:26:37 -0500
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 14:26:37 EST
From: ZJ Laczik <Laczik@eng.ox.ac.uk>
Organization: University of Oxford
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.x] fs/Kconfig: fix missing CONFIG_ROOT_NFS option
Date: Sun, 2 Mar 2008 19:13:53 +0000
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021913.54107.Laczik@eng.ox.ac.uk>
X-Oxford-Username: laczik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The CONFIG_ROOT_NFS option has been missing at least since 2.6.18,
fix is attached below:

---
diff -uNr a/fs/Kconfig b/fs/Kconfig
--- a/fs/Kconfig	2008-01-24 22:58:37.000000000 +0000
+++ b/fs/Kconfig	2008-03-02 17:59:54.000000000 +0000
@@ -1743,7 +1743,7 @@
 
 config ROOT_NFS
 	bool "Root file system on NFS"
-	depends on NFS_FS=y && IP_PNP
+	depends on NFS_FS && IP_PNP
 	help
 	  If you want your Linux box to mount its whole root file system (the
 	  one containing the directory /) from some other computer over the
---

John

-- 
Dr ZJ Laczik
=========================
Oxford Optics Ltd.
29 Harbord Road
Oxford OX2 8LH, UK
=========================
University of Oxford
Dept. of Engineering Sci.
Parks Road
Oxford OX1 3PJ, UK
phone: +44 1865 273115
fax:   +44 1865 273905
=========================
