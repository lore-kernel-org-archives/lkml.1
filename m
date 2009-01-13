Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZAMGjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZAMGjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZAMGjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:39:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZAMGjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:39:16 -0500
Subject: [PATCH -tip] coda_psdev.h: extern's make no sense in userspace
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       sam@ravnborg.org, harvey.harrison@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, gorcunov@gmail.com
Content-Type: text/plain
Date: Tue, 13 Jan 2009 12:06:54 +0530
Message-Id: <1231828614.3212.15.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix make headers_check warning:

 usr/include/linux/coda_psdev.h:90: extern's make no sense in userspace

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/coda_psdev.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 07ae8f8..c620958 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -87,6 +87,8 @@ struct upc_req {
  * Statistics
  */
 
+#ifdef __KERNEL__
 extern struct venus_comm coda_comms[];
+#endif /* __KERNEL__ */
 
 #endif
-- 
1.5.6.6



