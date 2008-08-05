Return-Path: <linux-kernel-owner+w=401wt.eu-S1763950AbYHEWHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763950AbYHEWHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbYHEWHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:07:17 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48246 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbYHEWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:07:16 -0400
Date: Tue, 5 Aug 2008 14:59:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>,
       schwidefsky@de.ibm.com
Subject: [PATCH] docbook: fix s390 fatal error after header files moved
Message-Id: <20080805145929.0443f8bf.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix (fatal error) s390 docbook file to handle renamed header files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/s390-drivers.tmpl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.27-rc1-git6.orig/Documentation/DocBook/s390-drivers.tmpl
+++ linux-2.6.27-rc1-git6/Documentation/DocBook/s390-drivers.tmpl
@@ -100,7 +100,7 @@
       the hardware structures represented here, please consult the Principles
       of Operation.
     </para>
-!Iinclude/asm-s390/cio.h
+!Iarch/s390/include/asm/cio.h
     </sect1>
     <sect1 id="ccwdev">
      <title>ccw devices</title>
@@ -114,7 +114,7 @@
       ccw device structure. Device drivers must not bypass those functions
       or strange side effects may happen.
     </para>
-!Iinclude/asm-s390/ccwdev.h
+!Iarch/s390/include/asm/ccwdev.h
 !Edrivers/s390/cio/device.c
 !Edrivers/s390/cio/device_ops.c
     </sect1>
@@ -125,7 +125,7 @@
 	measurement data which is made available by the channel subsystem
 	for each channel attached device.
   </para>
-!Iinclude/asm-s390/cmb.h
+!Iarch/s390/include/asm/cmb.h
 !Edrivers/s390/cio/cmf.c
     </sect1>
   </chapter>
@@ -142,7 +142,7 @@
   </para>
    <sect1 id="ccwgroupdevices">
     <title>ccw group devices</title>
-!Iinclude/asm-s390/ccwgroup.h
+!Iarch/s390/include/asm/ccwgroup.h
 !Edrivers/s390/cio/ccwgroup.c
    </sect1>
   </chapter>
