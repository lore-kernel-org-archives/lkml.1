Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbZDCTDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbZDCTDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZDCTDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:03:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49894 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbZDCTDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:03:32 -0400
Message-ID: <49D65D35.2090802@redhat.com>
Date: Fri, 03 Apr 2009 14:02:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] include types.h in fiemap.h now that it's exported
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include <linux/types.h> in fiemap.h, Sam Ravnborg pointed
out that this was missing in this newly-exported header which
uses the __u32 and __u64 types.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
cc: Sam Ravnborg <sam@ravnborg.org>
--

Index: linux-2.6/include/linux/fiemap.h
===================================================================
--- linux-2.6.orig/include/linux/fiemap.h
+++ linux-2.6/include/linux/fiemap.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_FIEMAP_H
 #define _LINUX_FIEMAP_H
 
+#include <linux/types.h>
+
 struct fiemap_extent {
 	__u64 fe_logical;  /* logical offset in bytes for the start of
 			    * the extent from the beginning of the file */

