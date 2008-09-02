Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYIBSgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYIBSgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYIBSf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:35:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:54482 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYIBSf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:35:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jt/a8MZmehbqTGMfz8MQeDkVPNPkSEPnxkVOvI/fWPzYFZDJGf39ZmEupL4XMrJU97
         GJuBjBurL5I3Eu7TlcPt10wmi7zkU0r4d/Pnf2Q5+BNARFxx5xh3dUtI37hl+7ff++cz
         Bx0NV1YBOQte6D7zUX8srcvz3Dj3jkdLRHN2M=
Subject: Re: [PATCH 1/2] byteorder: add a new include/linux/swab.h to
	define byteswapping functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, v4l <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <200808301436.22322.hverkuil@xs4all.nl>
References: <1218324197.24441.20.camel@brick>
	 <200808301436.22322.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 11:35:52 -0700
Message-Id: <1220380552.2137.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [buildfix-PATCH] byteorder: remove direct includes of linux/byteorder/swabb.h

All of the functionality has been collected in linux/swab.h

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/dvb/ttpci/av7110.c |    2 +-
 kernel/rcupreempt.c              |    2 +-
 tests/rcutorture.c               |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index c0a1746..792a175 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -36,7 +36,7 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 #include <linux/smp_lock.h>
 
 #include <linux/kernel.h>
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index ca4bbbe..494d0e8 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -54,7 +54,7 @@
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 #include <linux/cpumask.h>
 #include <linux/rcupreempt_trace.h>
 
diff --git a/tests/rcutorture.c b/tests/rcutorture.c
index 90b5b12..67856af 100644
--- a/tests/rcutorture.c
+++ b/tests/rcutorture.c
@@ -42,7 +42,7 @@
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
-- 
1.6.0.1.400.ga23d3



