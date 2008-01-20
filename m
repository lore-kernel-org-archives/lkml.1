Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYATWRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYATWRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 17:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbYATWQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 17:16:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:40280 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYATWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 17:16:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t3MUsKspdWK7uiHgQp9oHgIGbxLv/EXAw9Hqcq+AbjCu7tET0A2YUPFXpyYRNCf7Mo0zFgfmG1HlzNgv2vKxQRaedUjaffGmj7XxR5JdKK/MzgAzOT6sBJd3dnXdLCv272A5/QCIX4IMb1M+Gm875Sstffv+ExpQwclHtwqL7GQ=
Subject: [PATCH] x86: add vdso32-int80-syms.lds to .gitignore
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 14:16:52 -0800
Message-Id: <1200867412.5724.203.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the generated files was missed in gitignore

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/vdso/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/.gitignore b/arch/x86/vdso/.gitignore
index b9030e5..60274d5 100644
--- a/arch/x86/vdso/.gitignore
+++ b/arch/x86/vdso/.gitignore
@@ -3,3 +3,4 @@ vdso-syms.lds
 vdso32-syms.lds
 vdso32-syscall-syms.lds
 vdso32-sysenter-syms.lds
+vdso32-int80-syms.lds
-- 
1.5.4.rc3.1118.gf6754c



