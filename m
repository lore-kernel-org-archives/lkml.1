Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0BHG3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:29:30 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:55041 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab0BHG32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:29:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=lA/xlQAQtKbqKtMgrQ7fZBDuWL7GhJdYMsyPnrfphwUwRuhwloPWkJyYD2C0+NGd+5
         CR1Z/3WkhmF4Ownb4P0KvBA12+UQdtMtFNVJ70/pk8ExIIuh7XSeHguplfJ6ptiLe7u7
         PoQhc99oy0gOcVYadA5b3MgSvyeO9DwMfmPr0=
MIME-Version: 1.0
Date: Mon, 8 Feb 2010 14:29:27 +0800
Message-ID: <628d1651002072229o1ab44208g4a881b9818f08c0d@mail.gmail.com>
Subject: [PATCH] security/integrity/ima/ima_fs.c: Fix coding style
From: wzt wzt <wzt.wzt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: zohar@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: wzt <zhitong.wangzt@alibaba-inc.com>

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 0c72c9c..2c6a4eb 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -282,7 +282,7 @@ static atomic_t policy_opencount = ATOMIC_INIT(1);
 /*
  * ima_open_policy: sequentialize access to the policy file
  */
-int ima_open_policy(struct inode * inode, struct file * filp)
+int ima_open_policy(struct inode *inode, struct file *filp)
 {
        /* No point in being allowed to open it if you aren't going to write */
        if (!(filp->f_flags & O_WRONLY))
