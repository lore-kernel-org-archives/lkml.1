Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZG0QHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZG0QHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZG0QHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:07:14 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52143 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZG0QHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:07:13 -0400
Date: Mon, 27 Jul 2009 09:06:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Subject: [PATCH] documentation: make it clear that sysfs is optional
Message-Id: <20090727090642.0e495919.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A6DD0AB.0149:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Subject: [PATCH] documentation: make it clear that sysfs is optional

The original text suggested that sysfs is mandatory and always
compiled in the kernel.

Signed-off-by: Lucian Adrian Grijincu <lgrijincu@ixiacom.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/filesystems/sysfs.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20090727.orig/Documentation/filesystems/sysfs.txt
+++ linux-next-20090727/Documentation/filesystems/sysfs.txt
@@ -23,7 +23,8 @@ interface. 
 Using sysfs
 ~~~~~~~~~~~
 
-sysfs is always compiled in. You can access it by doing:
+sysfs is always compiled in if CONFIG_SYSFS is defined. You can access
+it by doing:
 
     mount -t sysfs sysfs /sys 
 


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
