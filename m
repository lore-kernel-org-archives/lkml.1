Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYGBOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYGBOs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYGBOsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:48:47 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:36275 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYGBOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:48:47 -0400
Message-ID: <486B951A.3060600@skyrush.com>
Date: Wed, 02 Jul 2008 09:47:54 -0500
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080514)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com>	<87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com>	<48630286.2050006@skyrush.com>	<87wskck5wi.fsf@devron.myhome.or.jp>	<48639863.808@skyrush.com>	<877iccxnwi.fsf@devron.myhome.or.jp>	<4863B9AF.4080105@skyrush.com>	<87zlp8w4br.fsf@devron.myhome.or.jp>	<4863D037.90504@skyrush.com>	<486476A5.7040801@skyrush.com> <20080701162714.dfdbd7c1.akpm@linux-foundation.org>
In-Reply-To: <20080701162714.dfdbd7c1.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020809090403070908090802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020809090403070908090802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> Can we update Documentation/filesystems/vfat.txt please?

Here's a patch to that doc file.

	-Joe

--------------020809090403070908090802
Content-Type: text/x-patch;
 name="vfat_doc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vfat_doc.patch"

Signed-off-by: Joe Peterson <joe@skyrush.com>

--

--- linux/Documentation/filesystems/vfat.txt.orig	2008-05-31 12:07:25.000000000 -0500
+++ linux/Documentation/filesystems/vfat.txt	2008-07-02 09:40:48.000000000 -0500
@@ -96,6 +96,14 @@
 			emulate the Windows 95 rule for create.
 		 Default setting is `lower'.
 
+tz=UTC        -- Interpret timestamps as UTC rather than local time.
+                 This option disables the conversion of timestamps
+                 between local time (as used by Windows on FAT) and UTC
+                 (which Linux uses internally).  This is particuluarly
+                 useful when mounting devices (like digital cameras)
+                 that are set to UTC in order to avoid the pitfalls of
+                 local time.
+
 <bool>: 0,1,yes,no,true,false
 
 TODO

--------------020809090403070908090802--
