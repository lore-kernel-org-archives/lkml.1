Return-Path: <linux-kernel-owner+w=401wt.eu-S965144AbXBYVkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965144AbXBYVkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXBYVkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:40:39 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:32874 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965144AbXBYVki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:40:38 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 25 Feb 2007 16:33:32 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: David Woodhouse <dwmw2@infradead.org>, kaber@trash.net
Subject: [PATCH] Kbuild: Remove "unifdef" entries for files that generate
 nothing.
Message-ID: <Pine.LNX.4.64.0702251629520.28950@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove, from their corresponding Kbuild files, entries for header
files that generate content-free sanitized header files.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 include/linux/Kbuild                |    3 ---
 include/linux/netfilter_ipv4/Kbuild |    1 -
 2 files changed, 4 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e81e301..3c31650 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -238,7 +238,6 @@ unifdef-y += ipv6_route.h
 unifdef-y += isdn.h
 unifdef-y += isdnif.h
 unifdef-y += isdn_ppp.h
-unifdef-y += isicom.h
 unifdef-y += jbd.h
 unifdef-y += joystick.h
 unifdef-y += kdev_t.h
@@ -313,13 +312,11 @@ unifdef-y += socket.h
 unifdef-y += sonet.h
 unifdef-y += sonypi.h
 unifdef-y += soundcard.h
-unifdef-y += stat.h
 unifdef-y += stddef.h
 unifdef-y += sysctl.h
 unifdef-y += tcp.h
 unifdef-y += time.h
 unifdef-y += timex.h
-unifdef-y += tty.h
 unifdef-y += types.h
 unifdef-y += udf_fs_i.h
 unifdef-y += udp.h
diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index 1803378..ea17e7f 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -50,7 +50,6 @@ header-y += ipt_TTL.h
 header-y += ipt_ULOG.h

 unifdef-y += ip_conntrack.h
-unifdef-y += ip_conntrack_h323.h
 unifdef-y += ip_conntrack_irc.h
 unifdef-y += ip_conntrack_pptp.h
 unifdef-y += ip_conntrack_proto_gre.h
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
