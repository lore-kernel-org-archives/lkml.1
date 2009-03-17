Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZCQVHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZCQVHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZCQVHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:07:32 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45521 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbZCQVHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:07:31 -0400
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Mar 2009 17:07:31 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=dOpqS/LDPkc32rvNPHQ3jsGKlGlFd9jyG4e3p6VimKaEP0eWXyM1weL1rXOakL5fQR
         ymXKBrqnRAeTQBgRpsqTtqCP7wdSYv0SZJRIz6bMSMz81mGQHxqla4npjeonQXnngTtr
         JCCh7OIH+eG1ZdwI3DT4jppIJtT5rHJgQX+bo=
From: Alessio Igor Bogani <abogani@texware.it>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org, video4linux-list@redhat.com,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] radio-mr800.c: Missing mutex include
Date: Tue, 17 Mar 2009 22:00:18 +0100
Message-Id: <1237323618-6464-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
pulled in indirectly by one of the headers it already includes, the
right thing is to include it directly.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/media/radio/radio-mr800.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index fdfc7bf..4d91148 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -58,6 +58,7 @@
 #include <media/v4l2-ioctl.h>
 #include <linux/usb.h>
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO */
+#include <linux/mutex.h>
 
 /* driver and module definitions */
 #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
-- 
1.6.0.4

