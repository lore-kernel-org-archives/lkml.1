Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXI3LoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXI3LoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 07:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbXI3LoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 07:44:11 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:56091 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbXI3LoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 07:44:10 -0400
Content-Disposition: inline
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Linux-pm mailing list" <uclinux-v850@lsi.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, Rafael Wysocki <rjw@sisk.pl>
Subject: Fwd: [Suspend2-devel] [patch] 2.2.10.3 build fixes
Date: Sun, 30 Sep 2007 21:44:08 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200709302144.08688.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael et al.

This looks like it will be vanilla material, maybe 2.6.23 material?

Regards,

Nigel
----------  Forwarded Message  ----------

Subject: [Suspend2-devel] [patch] 2.2.10.3 build fixes
Date: Sunday 30 September 2007
From: "Roman Dubtsov" (dubtsov gmail com)

Hi,

I have recently run into build issue with 2.6.22 and tuxonice
2.2.10.3. When building custom kernel with make-kpkg the process
failed with the message saying: "fs.h requires linux/freezer.h, which
does not exist in exported headers". Here's quick-n-dirty patch which
fixes this. Hope it is usefull.

--- 2.6.22-toi/include/linux/Kbuild.orig  2007-09-30 01:21:30.000000000 +0700
+++ 2.6.22-toi/include/linux/Kbuild       2007-09-29 23:52:52.000000000 +0700
@@ -202,6 +202,7 @@ unifdef-y += filter.h
 unifdef-y += flat.h
 unifdef-y += futex.h
 unifdef-y += fs.h
+unifdef-y += freezer.h
 unifdef-y += gameport.h
 unifdef-y += generic_serial.h
 unifdef-y += genhd.h

