Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZGQVwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZGQVwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 17:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbZGQVwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 17:52:12 -0400
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:47523 "HELO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753402AbZGQVwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 17:52:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] aio.h: remove duplicate #include
Date: Fri, 17 Jul 2009 17:52:08 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901AC20DA@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio.h: remove duplicate #include
Thread-Index: AcoHKNTSqpD2Nr+9T6+eZIekcCG7hQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Jul 2009 21:52:09.0997 (UTC) FILETIME=[D5C42BD0:01CA0728]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate #include <linux/aio_abi.h> in aio.h.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/include/linux/aio.h b/include/linux/aio.h
index 47f7d93..aea219d 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -225,8 +225,6 @@ static inline void exit_aio(struct mm_struct *mm) { }
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
-#include <linux/aio_abi.h>
-
 static inline struct kiocb *list_kiocb(struct list_head *h)
 {
        return list_entry(h, struct kiocb, ki_list);
