Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZBFGST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZBFGST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZBFGSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:18:08 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:31456 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZBFGSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:18:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YPbrW+nTWIvRE2jI7puJnxNtVR6x3tJ98fDZtATxGsdMVdiQO6Dtd0CRHWa7g+/Vgo
         do1H1W6F2AA3M/UbPfsKJq4Sigz4HPxJ1YNDi+ZndlOgduYp289jEC7+S+U3R5+L6FeQ
         fl89K9TSUNmPsuZOvqE93oc6lOtqx/wV8ceSA=
MIME-Version: 1.0
Date: Fri, 6 Feb 2009 15:18:04 +0900
Message-ID: <b294a32a0902052218y6f4f9f75h5616f285d306e9d9@mail.gmail.com>
Subject: [PATCH] jbd header comment typo fix
From: Kazuo Moriwaka <moriwaka@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sighned-off-by: Kazuo Moriwaka <moriwaka@redhat.com>

    jbd header comment typo fix

---
 jbd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 64246dc..e8ca681 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -35,7 +35,7 @@
 #define journal_oom_retry 1

 /*
- * Define JBD_PARANIOD_IOFAIL to cause a kernel BUG() if ext3 finds
+ * Define JBD_PARANOID_IOFAIL to cause a kernel BUG() if ext3 finds
  * certain classes of error which can occur due to failed IOs.  Under
  * normal use we want ext3 to continue after such errors, because
  * hardware _can_ fail, but for debugging purposes when running tests on

--
Kazuo Moriwaka
