Return-Path: <linux-kernel-owner+w=401wt.eu-S1031384AbXEDQre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031384AbXEDQre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031386AbXEDQrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:47:33 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60131 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031384AbXEDQrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:47:32 -0400
X-Originating-Ip: 72.143.66.196
Date: Fri, 4 May 2007 12:47:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, jirislaby@gmail.com
Subject: [PATCH] KBUILD: Drop tty.h and isicom.h from include/linux/Kbuild.
Message-ID: <Pine.LNX.4.64.0705041242490.27723@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Drop the entries for tty.h and isicom.h from the include/linux/Kbuild
file, since "make headers_install" just generates empty files for
them.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

i've submitted a patch to do this at least twice before.  is there
some reason those empty generated header are being so tenacious?

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 4ff0f57..63de91a 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -239,7 +239,6 @@ unifdef-y += ipv6_route.h
 unifdef-y += isdn.h
 unifdef-y += isdnif.h
 unifdef-y += isdn_ppp.h
-unifdef-y += isicom.h
 unifdef-y += jbd.h
 unifdef-y += joystick.h
 unifdef-y += kdev_t.h
@@ -320,7 +319,6 @@ unifdef-y += sysctl.h
 unifdef-y += tcp.h
 unifdef-y += time.h
 unifdef-y += timex.h
-unifdef-y += tty.h
 unifdef-y += types.h
 unifdef-y += udf_fs_i.h
 unifdef-y += udp.h
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
