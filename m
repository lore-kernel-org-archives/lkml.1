Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbXFDTaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbXFDTaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbXFDT3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:29:52 -0400
Received: from bay0-omc3-s29.bay0.hotmail.com ([65.54.246.229]:41426 "EHLO
	bay0-omc3-s29.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758470AbXFDT3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:29:51 -0400
Message-ID: <BAY139-F12A4B5AD078778194C9A74A3210@phx.gbl>
X-Originating-IP: [82.67.65.131]
X-Originating-Email: [tobiasoed@hotmail.com]
From: "Tobias Oed" <tobiasoed@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH: SELinux] Use %lu for inode->i_no when printing
Date: Mon, 04 Jun 2007 15:29:49 -0400
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 04 Jun 2007 19:29:50.0527 (UTC) FILETIME=[B81DF4F0:01C7A6DE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Inode numbers are unsigned long and so need to %lu as format string of 
printf. I have no idea why the __attribute__((format of  audit_log_format 
doesn't give us a warning.
Compile tested only.

Signed-of-by: Tobias Oed <tobiasoed@hotmail.com>


--- linux-2.6.21.3.orig/security/selinux/avc.c  2007-06-04 
21:21:58.000000000 +0200
+++ linux-2.6.21.3/security/selinux/avc.c       2007-06-04 
21:19:22.000000000 +0200
@@ -584,7 +584,7 @@
                                }
                        }
                        if (inode)
-                               audit_log_format(ab, " dev=%s ino=%ld",
+                               audit_log_format(ab, " dev=%s ino=%lu",
                                                 inode->i_sb->s_id,
                                                 inode->i_ino);
                        break;

_________________________________________________________________
Get a preview of Live Earth, the hottest event this summer - only on MSN 
http://liveearth.msn.com?source=msntaglineliveearthhm

