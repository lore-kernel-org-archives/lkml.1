Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbYEQVCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbYEQVCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYEQVCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:02:32 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49228 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbYEQVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:02:31 -0400
Date: Sat, 17 May 2008 17:02:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Move <linux/in6.h> from header-y to unifdef-y.
Message-ID: <alpine.LFD.1.10.0805171700210.27482@localhost.localdomain>
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


Given that <linux/in6.h> contains a __KERNEL__ test, it should be
unifdef-ed.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  that's it, there were just the two of them.


diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b7d81b2..54a4cfb 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -92,7 +92,6 @@ header-y += if_slip.h
 header-y += if_strip.h
 header-y += if_tun.h
 header-y += if_tunnel.h
-header-y += in6.h
 header-y += in_route.h
 header-y += ioctl.h
 header-y += ip6_tunnel.h
@@ -236,6 +235,7 @@ unifdef-y += if_vlan.h
 unifdef-y += igmp.h
 unifdef-y += inet_diag.h
 unifdef-y += in.h
+unifdef-y += in6.h
 unifdef-y += inotify.h
 unifdef-y += input.h
 unifdef-y += ip.h

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
