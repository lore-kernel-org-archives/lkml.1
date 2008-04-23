Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYDWQ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYDWQ71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYDWQ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:59:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18324 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbYDWQ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:59:05 -0400
Date: Wed, 23 Apr 2008 09:56:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
       jejb <James.Bottomley@HansenPartnership.com>
Cc: gregkh <greg@kroah.com>, akpm <akpm@linux-foundation.org>,
       sfr@canb.auug.org.au
Subject: [PATCH -next 2/2] sysfs: sysfs_update_group stub for CONFIG_SYSFS=n
Message-Id: <20080423095622.25e29f45.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

scsi_transport_spi uses sysfs_update_group() when CONFIG_SYSFS=n,
so provide a stub for it.

next-20080423/drivers/scsi/scsi_transport_spi.c:1467: error: implicit declaration of function 'sysfs_update_group'
make[3]: *** [drivers/scsi/scsi_transport_spi.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/sysfs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- next-20080423.orig/include/linux/sysfs.h
+++ next-20080423/include/linux/sysfs.h
@@ -191,6 +191,12 @@ static inline int sysfs_create_group(str
 	return 0;
 }
 
+static inline int sysfs_update_group(struct kobject *kobj,
+				const struct attribute_group *grp)
+{
+	return 0;
+}
+
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
