Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab0BYPKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:10:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab0BYPKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:10:05 -0500
Date: Thu, 25 Feb 2010 16:08:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm]
	kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-
	and-resolve-limit.cleanup
Message-ID: <20100225150826.GA22440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial, kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
forgot to kill the declaration of call_usermodehelper_stdinpipe() which no
longer exists.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

--- mm/include/linux/kmod.h~0_KILL_DECL	2010-02-25 15:57:02.000000000 +0100
+++ mm/include/linux/kmod.h	2010-02-25 15:58:20.000000000 +0100
@@ -73,8 +73,6 @@ struct subprocess_info *call_usermodehel
 /* Set various pieces of state into the subprocess_info structure */
 void call_usermodehelper_setkeys(struct subprocess_info *info,
 				 struct key *session_keyring);
-int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
-				  struct file **filp);
 void call_usermodehelper_setfns(struct subprocess_info *info,
 		    int (*init)(struct subprocess_info *info),
 		    void (*cleanup)(struct subprocess_info *info),

