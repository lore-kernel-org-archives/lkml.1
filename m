Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYCVSUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYCVSUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbYCVSUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:20:35 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40681 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYCVSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:20:34 -0400
Date: Sat, 22 Mar 2008 14:20:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove duplicate, conflicting entry for oom.h.
Message-ID: <alpine.LFD.1.00.0803221419130.22368@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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


oom.h is already tagged for unifdef'ing, so its entry as a simple
exportable header should be deleted.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 4108b38..11cbafd 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -116,7 +116,6 @@ header-y += nfs2.h
 header-y += nfs4_mount.h
 header-y += nfs_mount.h
 header-y += nl80211.h
-header-y += oom.h
 header-y += param.h
 header-y += pci_regs.h
 header-y += pfkeyv2.h

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
