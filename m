Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbYJFW13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbYJFW13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 18:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYJFW1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 18:27:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:39210 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYJFW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 18:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=SE7po5wFczsDIgRgcaslRiVAT0EaZyAkapVKj6oTtbG7rWWw66c337y9KwWeX0tzXq
         JtOi7r0kXTb48p2aLLBR8TzAPSewKbCIMaf7p+WG1y7C6szA6jHq24Espz4H7JSH/Ayp
         kzxgXjtKvcR4q4sWT/GQgKHNaTR0y3jyn8phU=
Date: Tue, 7 Oct 2008 02:29:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: remove unused ADDBUF macro
Message-ID: <20081006222959.GA3466@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added to proc.git]

commit abac1335ec9c43834ff764eee3c4d026b6b9bba6
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Tue Oct 7 01:58:45 2008 +0400

    proc: remove now unneeded ADDBUF macro
    
    After local seq_file conversion it was forgotten.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 1c8d7b5..f4bc0e7 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -86,11 +86,6 @@
 #include <asm/processor.h>
 #include "internal.h"
 
-/* Gcc optimizes away "strlen(x)" for constant x */
-#define ADDBUF(buffer, string) \
-do { memcpy(buffer, string, strlen(string)); \
-     buffer += strlen(string); } while (0)
-
 static inline void task_name(struct seq_file *m, struct task_struct *p)
 {
 	int i;
