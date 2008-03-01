Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbYCAHzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbYCAHzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 02:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYCAHzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 02:55:04 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50789 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYCAHzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 02:55:02 -0500
Date: Sat, 1 Mar 2008 09:54:59 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2o: remove static inline forward declarations
Message-ID: <Pine.LNX.4.64.0803010948110.12640@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-274662813-1204358099=:12640"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-274662813-1204358099=:12640
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Nothing in between of them and the later declaration with body
needs them.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
Here's another this kind of double declaration, ie., prototype and with 
body later on in the same file (made my inline size tester to fail in
compile there because it didn't know about the other, duplicate 
defination).

 include/linux/i2o.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 7da5b98..a2f5861 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -613,14 +613,9 @@ struct i2o_sys_tbl {
 extern struct list_head i2o_controllers;
 
 /* Message functions */
-static inline struct i2o_message *i2o_msg_get(struct i2o_controller *);
 extern struct i2o_message *i2o_msg_get_wait(struct i2o_controller *, int);
-static inline void i2o_msg_post(struct i2o_controller *, struct i2o_message *);
-static inline int i2o_msg_post_wait(struct i2o_controller *,
-				    struct i2o_message *, unsigned long);
 extern int i2o_msg_post_wait_mem(struct i2o_controller *, struct i2o_message *,
 				 unsigned long, struct i2o_dma *);
-static inline void i2o_flush_reply(struct i2o_controller *, u32);
 
 /* IOP functions */
 extern int i2o_status_get(struct i2o_controller *);
-- 
1.5.2.2

---696243703-274662813-1204358099=:12640--
