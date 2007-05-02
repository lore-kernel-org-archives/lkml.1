Return-Path: <linux-kernel-owner+w=401wt.eu-S1767157AbXEBSaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767157AbXEBSaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767158AbXEBSaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:30:14 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:47690 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767157AbXEBSaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:30:12 -0400
From: Balbir Singh <balbir@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jlan@sgi.com, nagar1234@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 03 May 2007 00:00:04 +0530
Message-Id: <20070502183004.28574.12919.sendpatchset@balbir-laptop>
Subject: [PATCH -mm] Add taskstats.h to kbuild
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



From: David Woodhouse <dwmw2@infradead.org>

Add taskstats.h to include/linux/Kbuild, make headers_install would then
pickup taskstats.h. This needs to be done as taskstats.h is a user interface
header.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/Kbuild~taskstats-add-header-to-kbuild include/linux/Kbuild
--- linux-2.6.20/include/linux/Kbuild~taskstats-add-header-to-kbuild	2007-05-02 23:14:06.000000000 +0530
+++ linux-2.6.20-balbir/include/linux/Kbuild	2007-05-02 23:14:28.000000000 +0530
@@ -140,6 +140,7 @@ header-y += sockios.h
 header-y += som.h
 header-y += sound.h
 header-y += synclink.h
+header-y += taskstats.h
 header-y += telephony.h
 header-y += termios.h
 header-y += ticable.h
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
