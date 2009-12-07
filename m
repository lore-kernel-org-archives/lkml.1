Return-Path: <linux-kernel-owner+w=401wt.eu-S934542AbZLGDxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934542AbZLGDxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934523AbZLGDw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:52:58 -0500
Received: from xenotime.net ([72.52.64.118]:42698 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934494AbZLGDwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:52:54 -0500
Date: Sun, 06 Dec 2009 18:30:44 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Luis Garces-Erice <lge@ieee.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/6] docs: better explanation of procs_running
Message-ID: <12601530441257@xenotime.net>
In-Reply-To: <12601530442994@xenotime.net>
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

