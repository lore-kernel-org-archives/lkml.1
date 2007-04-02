Return-Path: <linux-kernel-owner+w=401wt.eu-S965866AbXDBVI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866AbXDBVI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965889AbXDBVI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:08:59 -0400
Received: from mailgate2.urz.uni-halle.de ([141.48.3.8]:57872 "EHLO
	mailgate2.urz.uni-halle.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965866AbXDBVI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:08:58 -0400
X-Greylist: delayed 1536 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 17:08:57 EDT
Date: Mon, 02 Apr 2007 22:43:13 +0200 (MEST)
From: Bert Wesarg <wesarg@informatik.uni-halle.de>
Subject: [PTACH] kernel/params.c: fix lying comment for param_array()
X-X-Sender: wesarg@turing
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Message-id: <Pine.GSO.4.56.0704022241010.6377@turing>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Content-transfer-encoding: 7BIT
X-Scan-Signature: 45b4346e648713a12013d52a301c36b3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bert Wesarg <wesarg@informatik.uni-halle.de>

This fixes the comment for the function param_array. Which lies that it
only *temporarily* mangle the input string @val.

Signed-off-by: Bert Wesarg <wesarg@informatik.uni-halle.de>

---

PS: please CC me, because i'm not subscripted to this list

 kernel/params.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --quilt old/kernel/params.c new/kernel/params.c
--- old/kernel/params.c
+++ new/kernel/params.c
@@ -267,11 +267,11 @@ int param_get_invbool(char *buffer, stru

 	val = !*(int *)kp->arg;
 	return param_get_bool(buffer, &dummy);
 }

-/* We cheat here and temporarily mangle the string. */
+/* We break the rule and mangle the string. */
 static int param_array(const char *name,
 		       const char *val,
 		       unsigned int min, unsigned int max,
 		       void *elem, int elemsize,
 		       int (*set)(const char *, struct kernel_param *kp),
