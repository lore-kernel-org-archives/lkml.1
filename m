Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbZEOMLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbZEOMLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZEOMLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:11:08 -0400
Received: from mail09.linbit.com ([212.69.161.110]:47019 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZEOMLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:11:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 01/16] DRBD: major.h
Date: Fri, 15 May 2009 14:10:28 +0200
Message-Id: <1242389443-3470-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242389443-3470-1-git-send-email-philipp.reisner@linbit.com>
References: <1242389443-3470-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have had a LANANA major number for years, and it is documented in devices.txt,
I think that this first patch can go upstream without further changes.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff --git a/include/linux/major.h b/include/linux/major.h
index 058ec15..6a8ca98 100644
--- a/include/linux/major.h
+++ b/include/linux/major.h
@@ -145,6 +145,7 @@
 #define UNIX98_PTY_MAJOR_COUNT	8
 #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
 
+#define DRBD_MAJOR		147
 #define RTF_MAJOR		150
 #define RAW_MAJOR		162
 
