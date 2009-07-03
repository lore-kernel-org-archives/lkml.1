Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZGCMqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZGCMqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbZGCMpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:45:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:59948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757853AbZGCMpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:45:34 -0400
Date: Fri, 3 Jul 2009 12:44:55 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, efault@gmx.de, heukelum@fastmail.fm,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, efault@gmx.de, heukelum@fastmail.fm,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246512440.13293.3.camel@marge.simson.net>
References: <1246512440.13293.3.camel@marge.simson.net>
Subject: [tip:x86/urgent] x86: Add missing annotation to arch/x86/lib/copy_user_64.S::copy_to_user
Message-ID: <tip-3fd382cedfb4fb742a8cc17ba15288ec03131db1@git.kernel.org>
Git-Commit-ID: 3fd382cedfb4fb742a8cc17ba15288ec03131db1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:44:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fd382cedfb4fb742a8cc17ba15288ec03131db1
Gitweb:     http://git.kernel.org/tip/3fd382cedfb4fb742a8cc17ba15288ec03131db1
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 2 Jul 2009 07:27:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 14:34:17 +0200

x86: Add missing annotation to arch/x86/lib/copy_user_64.S::copy_to_user

While examining symbol generation in perf_counter tools, I
noticed that copy_to_user() had no size in vmlinux's symtab.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <1246512440.13293.3.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/lib/copy_user_64.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index f118c11..6ba0f7b 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -75,6 +75,7 @@ ENTRY(copy_to_user)
 	jae bad_to_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
+ENDPROC(copy_to_user)
 
 /* Standard copy_from_user with segment limit checking */
 ENTRY(copy_from_user)
