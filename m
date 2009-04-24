Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbZDXQgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbZDXQgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZDXQgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:36:22 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41219 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbZDXQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:36:21 -0400
Date: Fri, 24 Apr 2009 12:35:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Makefile:  "make prepare" should be "make modules_prepare"
Message-ID: <alpine.LFD.2.00.0904241233220.22684@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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


Correct the Makefile help text to read "make modules_prepare".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  i'm fairly sure that the correct target for configuring external
module builds is "modules_prepare," no?

diff --git a/Makefile b/Makefile
index 9e5dc8f..5a96549 100644
--- a/Makefile
+++ b/Makefile
@@ -1293,7 +1293,7 @@ help:
 	@echo  '  dir/            - Build all files in dir and below'
 	@echo  '  dir/file.[ois]  - Build specified target only'
 	@echo  '  dir/file.ko     - Build module including final link'
-	@echo  '  prepare         - Set up for building external modules'
+	@echo  '  modules_prepare - Set up for building external modules'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'
 	@echo  '  kernelrelease	  - Output the release version string'



========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
