Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbXCXNia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbXCXNia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXCXNia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:38:30 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34124 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXCXNi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:38:29 -0400
X-Originating-Ip: 74.109.98.130
Date: Sat, 24 Mar 2007 09:35:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Delete unused header file media/wm8775.h.
Message-ID: <Pine.LNX.4.64.0703240932220.23458@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Delete the unreferenced header file include/media/wm8775.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

even the matching source file drivers/media/video/wm8775.c doesn't
include this header file.

diff --git a/include/media/wm8775.h b/include/media/wm8775.h
deleted file mode 100644
index 60739c5..0000000
--- a/include/media/wm8775.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
-    wm8775.h - definition for wm8775 inputs and outputs
-
-    Copyright (C) 2006 Hans Verkuil (hverkuil@xs4all.nl)
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#ifndef _WM8775_H_
-#define _WM8775_H_
-
-/* The WM8775 has 4 inputs and one output. Zero or more inputs
-   are multiplexed together to the output. Hence there are
-   16 combinations.
-   If only one input is active (the normal case) then the
-   input values 1, 2, 4 or 8 should be used. */
-
-#define WM8775_AIN1 1
-#define WM8775_AIN2 2
-#define WM8775_AIN3 4
-#define WM8775_AIN4 8
-
-#endif
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
