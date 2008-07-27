Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYG0Mee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYG0Mee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 08:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYG0MeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 08:34:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:20260 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYG0MeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 08:34:24 -0400
Message-ID: <488C6B4E.8040205@nixpanic.net>
Date: Sun, 27 Jul 2008 14:34:22 +0200
From: Niels de Vos <niels@nixpanic.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RESEND] [PATCH] linux/fs.h should include linux/path.h
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/fs.h> defines 'struct file' which uses 'struct path'. However
<linux/path.h> is not being included.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>

---
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d8e2762..a14f1c4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -289,6 +289,7 @@ extern int dir_notify_enable;
 #include <linux/mutex.h>
 #include <linux/capability.h>
 #include <linux/semaphore.h>
+#include <linux/path.h>

 #include <asm/atomic.h>
 #include <asm/byteorder.h>

