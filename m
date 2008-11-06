Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbYKFTLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbYKFTLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYKFTKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:10:55 -0500
Received: from smtp-out.google.com ([216.239.33.17]:21485 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYKFTKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:10:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=GdQMRZp1W29QtrdFxadUAQcuHztxGNgseplcHcobfij6lxnmHkcBATvfnGy7fIzzN
	umF4Ti9D390oMD4WPBXPQ==
MIME-Version: 1.0
Date: Thu, 6 Nov 2008 11:10:49 -0800
Message-ID: <b040c32a0811061110g69b6cc6cta88774b72e5b9163@mail.gmail.com>
Subject: [patch] enable wchan config menu item for x86-64
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I don't know when will you phase out /proc/pid/wchan.  Can we enable the
wchan config menu item for now on x86-64 arch?  This will at least allow
people to enable/disable frame pointers on scheduler functions.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e60c59b..38f9fb9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -367,7 +367,7 @@ config X86_RDC321X
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
-	depends on X86_32
+	depends on X86
 	help
 	  Calculate simpler /proc/<PID>/wchan values. If this option
 	  is disabled then wchan values will recurse back to the
