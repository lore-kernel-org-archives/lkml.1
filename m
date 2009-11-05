Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbZKEALR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbZKEALR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZKEALP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:11:15 -0500
Received: from xenotime.net ([72.52.64.118]:39030 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751716AbZKEALM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:11:12 -0500
Date: Wed, 04 Nov 2009 16:04:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Luis Garces-Erice <lge@ieee.org>
Subject: [PATCH 6/8] docs: explain procs_running better
Message-ID: <12573794923083@xenotime.net>
In-Reply-To: <1257379492822@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Luis Garces-Erice <lge@ieee.org>
Subject: Doc: better explanation of procs_running

the description in Documentation/filesystems/proc.txt of the
procs_running entry in /proc/stat is confusing (according to that
description, it looks as if procs_running could only be a number
between 0 and the number of CPUs).

Changed it to a more accurate description in the patch attached.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/filesystems/proc.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-2632-rc6.orig/Documentation/filesystems/proc.txt
+++ lnx-2632-rc6/Documentation/filesystems/proc.txt
@@ -1088,8 +1088,8 @@ The "processes" line gives the number  o
 includes (but  is not limited  to) those  created by  calls to the  fork() and
 clone() system calls.
 
-The  "procs_running" line gives the  number of processes  currently running on
-CPUs.
+The "procs_running" line gives the total number of threads that are
+running or ready to run (i.e., the total number of runnable threads).
 
 The   "procs_blocked" line gives  the  number of  processes currently blocked,
 waiting for I/O to complete.


-- 

