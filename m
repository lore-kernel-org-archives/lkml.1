Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZDJMND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZDJMND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZDJMMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:12:49 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39891 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbZDJMMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:12:48 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 01/14] DRBD: major.h
Date: Fri, 10 Apr 2009 14:12:12 +0200
Message-Id: <1239365545-10356-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have a LANANA major number for years, it is documented in devices.txt,
I think that this first patch can go upstream without further changes.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff -uNrp linux-2.6.30-rc1/include/linux/major.h linux-2.6.30-rc1-drbd/include/linux/major.h
--- linux-2.6.30-rc1/include/linux/major.h	2009-04-07 23:25:01.000000000 +0200
+++ linux-2.6.30-rc1-drbd/include/linux/major.h	2009-04-10 13:13:43.186539744 +0200
@@ -145,6 +145,7 @@
 #define UNIX98_PTY_MAJOR_COUNT	8
 #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
 
+#define DRBD_MAJOR		147
 #define RTF_MAJOR		150
 #define RAW_MAJOR		162
 
/home/phil/src/drbdXX/scripts
