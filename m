Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYEQU6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYEQU6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbYEQU6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:58:31 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:48804 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbYEQU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:58:31 -0400
Date: Sat, 17 May 2008 16:58:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] <linux/dlm_plock.h> should be "unifdef"ed.
Message-ID: <alpine.LFD.1.10.0805171656410.27432@localhost.localdomain>
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


Given that <linux/dlm_plock.h> contains a conditional __KERNEL__ test,
it should be moved from header-y to unifdef-y.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b7d81b2..5dfa739 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -105,7 +105,6 @@ header-y += ixjuser.h
 header-y += jffs2.h
 header-y += keyctl.h
 header-y += limits.h
-header-y += dlm_plock.h
 header-y += magic.h
 header-y += major.h
 header-y += matroxfb.h
@@ -190,6 +189,7 @@ unifdef-y += cyclades.h
 unifdef-y += dccp.h
 unifdef-y += dirent.h
 unifdef-y += dlm.h
+unifdef-y += dlm_plock.h
 unifdef-y += edd.h
 unifdef-y += elf.h
 unifdef-y += elfcore.h

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
