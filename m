Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbXCJWKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbXCJWKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXCJWKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:10:12 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:50491 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXCJWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:10:10 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 17:07:26 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, mlindner@syskonnect.de,
       rroesler@syskonnect.de
Subject: [PATCH] SYSKONNECT: Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101705160.28565@CPE00045a9c397f-CM001225dbafb6>
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


  Delete apparently unused header file drivers/net/skfp/h/lnkstat.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/net/skfp/h/lnkstat.h b/drivers/net/skfp/h/lnkstat.h
deleted file mode 100644
index c73dcd9..0000000
--- a/drivers/net/skfp/h/lnkstat.h
+++ /dev/null
@@ -1,84 +0,0 @@
-/******************************************************************************
- *
- *	(C)Copyright 1998,1999 SysKonnect,
- *	a business unit of Schneider & Koch & Co. Datensysteme GmbH.
- *
- *	This program is free software; you can redistribute it and/or modify
- *	it under the terms of the GNU General Public License as published by
- *	the Free Software Foundation; either version 2 of the License, or
- *	(at your option) any later version.
- *
- *	The information in this file is provided "AS IS" without warranty.
- *
- ******************************************************************************/
-
-/*
- * Definition of the Error Log Structure
- * This structure will be copied into the Error Log buffer
- * during the NDIS General Request ReadErrorLog by the MAC Driver
- */
-
-struct	s_error_log {
-
-	/*
-	 * place holder for token ring adapter error log (zeros)
-	 */
-	u_char	reserved_0 ;			/* byte 0 inside Error Log */
-	u_char	reserved_1 ;			/* byte 1 */
-	u_char	reserved_2 ;			/* byte 2 */
-	u_char	reserved_3 ;			/* byte 3 */
-	u_char	reserved_4 ;			/* byte 4 */
-	u_char	reserved_5 ;			/* byte 5 */
-	u_char	reserved_6 ;			/* byte 6 */
-	u_char	reserved_7 ;			/* byte 7 */
-	u_char	reserved_8 ;			/* byte 8 */
-	u_char	reserved_9 ;			/* byte 9 */
-	u_char	reserved_10 ;			/* byte 10 */
-	u_char	reserved_11 ;			/* byte 11 */
-	u_char	reserved_12 ;			/* byte 12 */
-	u_char	reserved_13 ;			/* byte 13 */
-
-	/*
-	 * FDDI link statistics
-	 */
-/*
- * smt error low
- */
-#define SMT_ERL_AEB	(1<<15)			/* A elast. buffer */
-#define SMT_ERL_BLC	(1<<14)			/* B link error condition */
-#define SMT_ERL_ALC	(1<<13)			/* A link error condition */
-#define SMT_ERL_NCC	(1<<12)			/* not copied condition */
-#define SMT_ERL_FEC	(1<<11)			/* frame error condition */
-
-/*
- * smt event low
- */
-#define SMT_EVL_NCE	(1<<5)
-
-	u_short	smt_error_low ;			/* byte 14/15 */
-	u_short	smt_error_high ;		/* byte 16/17 */
-	u_short	smt_event_low ;			/* byte 18/19 */
-	u_short	smt_event_high ;		/* byte 20/21 */
-	u_short	connection_policy_violation ;	/* byte 22/23 */
-	u_short port_event ;			/* byte 24/25 */
-	u_short set_count_low ;			/* byte 26/27 */
-	u_short set_count_high ;		/* byte 28/29 */
-	u_short	aci_id_code ;			/* byte 30/31 */
-	u_short	purge_frame_counter ;		/* byte 32/33 */
-
-	/*
-	 * CMT and RMT state machines
-	 */
-	u_short	ecm_state ;			/* byte 34/35 */
-	u_short	pcm_a_state ;			/* byte 36/37 */
-	u_short pcm_b_state ;			/* byte 38/39 */
-	u_short	cfm_state ;			/* byte 40/41 */
-	u_short	rmt_state ;			/* byte 42/43 */
-
-	u_short	not_used[30] ;			/* byte 44-103 */
-
-	u_short	ucode_version_level ;		/* byte 104/105 */
-
-	u_short	not_used_1 ;			/* byte 106/107 */
-	u_short not_used_2 ;			/* byte 108/109 */
-} ;
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
