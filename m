Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbYLKPOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbYLKPOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 10:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYLKPO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 10:14:28 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:36964 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbYLKPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 10:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=w0eR5rptGuXefbQZdBpVuGTQJf1mnMqc8S28OguZ7rwD/EVcUORgFc/HyRk7gLcXf9
         I0vdFIRTaMorBRDrtPAuQY+40BTWg9R9o/+77Ohw4EHj4nZWbl8Fwg9GRKDTx5t4y9mz
         CKN49l4CRramkSNW2cjPM7XD0Xvv355ZfMdqU=
Message-ID: <49412E4F.9080307@gmail.com>
Date: Thu, 11 Dec 2008 16:14:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/fastboot: include missing headers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now include/trace/boot.h doesn't need to include necessary headers
for its functions and structures because the files that include it already
do it.

But boot.h could be needed as well for further uses on other files.
So, this patch adds the necessary headers for future purposes...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/include/trace/boot.h b/include/trace/boot.h
index 3ec58b4..088ea08 100644
--- a/include/trace/boot.h
+++ b/include/trace/boot.h
@@ -1,6 +1,10 @@
 #ifndef _LINUX_TRACE_BOOT_H
 #define _LINUX_TRACE_BOOT_H
 
+#include <linux/module.h>
+#include <linux/kallsyms.h>
+#include <linux/init.h>
+
 /*
  * Structure which defines the trace of an initcall
  * while it is called.
-- 
1.6.0.4

