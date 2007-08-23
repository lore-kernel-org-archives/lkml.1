Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbXHWCZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbXHWCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXHWCZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:25:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44839 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbXHWCZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:25:20 -0400
Date: Thu, 23 Aug 2007 08:08:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jordan Crouse <jordan.crouse@amd.com>
cc: Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][trivial] drivers/video/geode/lxfb_core.c: Fix build
 warning
Message-ID: <alpine.LFD.0.999.0708230803460.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/video/geode/lxfb_core.c: In function 'lxfb_setup':
drivers/video/geode/lxfb_core.c:564: warning: unused variable 'opt'

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/video/geode/lxfb_core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 5e30b40..67d6bf6 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -561,8 +561,6 @@ static struct pci_driver lxfb_driver = {
 #ifndef MODULE
 static int __init lxfb_setup(char *options)
 {
-	char *opt;
-
 	if (!options || !*options)
 		return 0;
 
