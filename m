Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbZKMPQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbZKMPQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128AbZKMPQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:16:30 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:44441 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbZKMPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:09:04 -0500
Message-Id: <20091113150911.754163162@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 13 Nov 2009 16:08:38 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Joe Perches <joe@perches.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 14/52] [PATCH] MAINTAINERS: Add s390 drivers block
References: <20091113150824.351347652@de.ibm.com>
Content-Disposition: inline; filename=113-maintainers-update.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

There are currently 4 directories in drivers/s390
(block, char, cio, kvm) without maintainers.

Add drivers/s390/ to the s390 kvm section.
Add the rest to the default s390 section.
Add a W: link for drivers/s390/crypto/

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

Index: quilt-2.6/MAINTAINERS
===================================================================
--- quilt-2.6.orig/MAINTAINERS	2009-11-13 15:48:32.000000000 +0100
+++ quilt-2.6/MAINTAINERS	2009-11-13 16:08:15.000000000 +0100
@@ -3063,6 +3063,7 @@
 F:	Documentation/s390/kvm.txt
 F:	arch/s390/include/asm/kvm*
 F:	arch/s390/kvm/
+F:	drivers/s390/kvm/
 
 KEXEC
 M:	Eric Biederman <ebiederm@xmission.com>
@@ -4471,6 +4472,7 @@
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 F:	arch/s390/
+F:	drivers/s390/
 
 S390 NETWORK DRIVERS
 M:	Ursula Braun <ursula.braun@de.ibm.com>
@@ -4486,6 +4488,7 @@
 M:	Ralph Wuerthner <ralph.wuerthner@de.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
+W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 F:	drivers/s390/crypto/
 

