Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYAGLfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYAGLfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbYAGLf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:35:28 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:51279 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbYAGLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:35:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=s1cN3Usl7gnyaCF2rbPJ3bESO/8wvIcbWDzEczal7x/93znKiKhuxGGzTf79bBfT6rOFAqQblWGp2xSkD/5A7C7FGhFIV6gFCuky+egzPUli/UQuaFYQ9RBUMcd8ZkeyeU/JjeQzmQcel2BWNJyPO4l3AocGZdgWV6NF4YorZvk=
Message-ID: <4d8e3fd30801070335n79d910dbt48d0ef0f3597c670@mail.gmail.com>
Date: Mon, 7 Jan 2008 12:35:21 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH 1/5] Codying style fixes in ./arch/x86/ia32
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix one error reported by checkpatch,
it now reports:

total: 0 errors, 0 warnings, 42 lines checked

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/ia32/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/audit.c b/arch/x86/ia32/audit.c
index 91b7b59..5d7b381 100644
--- a/arch/x86/ia32/audit.c
+++ b/arch/x86/ia32/audit.c
@@ -27,7 +27,7 @@ unsigned ia32_signal_class[] = {

 int ia32_classify_syscall(unsigned syscall)
 {
-       switch(syscall) {
+       switch (syscall) {
        case __NR_open:
                return 2;
        case __NR_openat:
--
1.5.4.rc2.17.g257f




-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
