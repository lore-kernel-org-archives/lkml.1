Return-Path: <linux-kernel-owner+w=401wt.eu-S1762591AbXHNVq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591AbXHNVq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbXHNV0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:26:24 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45848 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758465AbXHNV0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:26:21 -0400
Date: Tue, 14 Aug 2007 23:26:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       chrisw@sous-sol.org
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] unexport cap_inode_killpriv
Message-ID: <20070814212613.GY18945@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc1-mm2:
>...
> +file-capabilities-clear-fcaps-on-inode-change.patch
> 
>  file caps update
>...

This patch removes the unused EXPORT_SYMBOL(cap_inode_killpriv).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
68ca3bcc4918d0b84a97318f60fb74c4600d9f6b 
diff --git a/security/commoncap.c b/security/commoncap.c
index 7816cdc..9ec5890 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -543,7 +543,6 @@ EXPORT_SYMBOL(cap_bprm_apply_creds);
 EXPORT_SYMBOL(cap_bprm_secureexec);
 EXPORT_SYMBOL(cap_inode_setxattr);
 EXPORT_SYMBOL(cap_inode_removexattr);
-EXPORT_SYMBOL(cap_inode_killpriv);
 EXPORT_SYMBOL(cap_task_post_setuid);
 EXPORT_SYMBOL(cap_task_kill);
 EXPORT_SYMBOL(cap_task_setscheduler);

