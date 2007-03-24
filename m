Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbXCXNdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbXCXNdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXCXNdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:33:18 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33727 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXCXNdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:33:17 -0400
X-Originating-Ip: 74.109.98.130
Date: Sat, 24 Mar 2007 09:29:31 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH]  Delete unused header file media/cs53l32a.h.
Message-ID: <Pine.LNX.4.64.0703240924420.23397@CPE00045a9c397f-CM001225dbafb6>
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


Delete the unreferenced header file include/media/cs53l32a.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not even the matching *source* file drivers/media/video/cs53l32a.c
includes this header file.  that would seem a pretty good sign that no
one loves it anymore.


diff --git a/include/media/cs53l32a.h b/include/media/cs53l32a.h
deleted file mode 100644
index bf76197..0000000
--- a/include/media/cs53l32a.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
-    cs53l32a.h - definition for cs53l32a inputs and outputs
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
-#ifndef _CS53L32A_H_
-#define _CS53L32A_H_
-
-/* There are 2 physical inputs, but the second input can be
-   placed in two modes, the first mode bypasses the PGA (gain),
-   the second goes through the PGA. Hence there are three
-   possible inputs to choose from. */
-
-/* CS53L32A HW inputs */
-#define CS53L32A_IN0 0
-#define CS53L32A_IN1 1
-#define CS53L32A_IN2 2
-
-#endif
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
