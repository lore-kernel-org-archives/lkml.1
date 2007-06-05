Return-Path: <linux-kernel-owner+w=401wt.eu-S1764323AbXFEKmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764323AbXFEKmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764011AbXFEKly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:41:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:54323 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763897AbXFEKlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eUVGCnlS9TMrXhD6kG8iryYSwm95MjACXB2ltTiW9s0ZoA9Zu7rztVUxlIlWxEbPk9tSj1CweoVv+HPQZwXKobxsPD6fKHER7QTeC64qSreCfowDfqg9YWUtE2SxLvILlCJ66SNdlC1zgLWkEtKscKGe02FuMlbc4tX/3BeT0cY=
Message-ID: <4bcb1f700706050341j2d772fc3lbd9a637ab869ee38@mail.gmail.com>
Date: Tue, 5 Jun 2007 16:11:52 +0530
From: "Ratnadeep Joshi" <ratn.josh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/atomic_ops.txt
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo in Documentation/atomic_ops.txt
Thanks,
- Ratnadeep Joshi

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 2a63d56..05851e9 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -149,7 +149,7 @@ defined which accomplish this:
        void smp_mb__before_atomic_dec(void);
        void smp_mb__after_atomic_dec(void);
        void smp_mb__before_atomic_inc(void);
-       void smp_mb__after_atomic_dec(void);
+       void smp_mb__after_atomic_inc(void);

 For example, smp_mb__before_atomic_dec() can be used like so:
