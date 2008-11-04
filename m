Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYKDWuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYKDWuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYKDWtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:49:45 -0500
Received: from xenotime.net ([72.52.64.118]:60712 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756740AbYKDWto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:49:44 -0500
Message-ID: <4910CE7C.2060709@xenotime.net>
Date: Tue, 04 Nov 2008 14:36:44 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 2/3] documentation: update s390 header file paths
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update Documentation/s390/ files to reflect changed header files locations.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/s390/Debugging390.txt |    2 +-
 Documentation/s390/cds.txt          |    2 +-
 Documentation/s390/s390dbf.txt      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- lin2628-rc3.orig/Documentation/s390/Debugging390.txt
+++ lin2628-rc3/Documentation/s390/Debugging390.txt
@@ -1402,7 +1402,7 @@ Syscalls are implemented on Linux for S3
 possibilities of these as the instruction is made up of a  0xA opcode & the second byte being
 the syscall number. They are traced using the simple command.
 TR SVC  <Optional value or range>
-the syscalls are defined in linux/include/asm-s390/unistd.h
+the syscalls are defined in linux/arch/s390/include/asm/unistd.h
 e.g. to trace all file opens just do
 TR SVC 5 ( as this is the syscall number of open )
 
--- lin2628-rc3.orig/Documentation/s390/cds.txt
+++ lin2628-rc3/Documentation/s390/cds.txt
@@ -98,7 +98,7 @@ platform. Some of the interface routines
 of them can be found on other Linux platforms implementations too.
 Miscellaneous function prototypes, data declarations, and macro definitions
 can be found in the architecture specific C header file
-linux/include/asm-s390/irq.h.
+linux/arch/s390/include/asm/irq.h.
 
 Overview of CDS interface concepts
 
--- lin2628-rc3.orig/Documentation/s390/s390dbf.txt
+++ lin2628-rc3/Documentation/s390/s390dbf.txt
@@ -2,7 +2,7 @@ S390 Debug Feature
 ==================
 
 files: arch/s390/kernel/debug.c
-       include/asm-s390/debug.h
+       arch/s390/include/asm/debug.h
 
 Description:
 ------------
