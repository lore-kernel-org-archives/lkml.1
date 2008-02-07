Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbYBGWKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbYBGWKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbYBGWJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:09:59 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:31014 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbYBGWJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:09:58 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix CONFIG_COMPAT_BRK help text
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 07 Feb 2008 14:09:54 -0800
Message-ID: <ada8x1wa05p.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Feb 2008 22:09:55.0385 (UTC) FILETIME=[2B80FA90:01C869D6]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_COMPAT_BRK=y means that heap randomization is turned off, so
it's *always* a safe choice.  I assume the help text is trying to say
that if one does not run ancient binaries, then enabling heap
randomization is safe.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
diff --git a/init/Kconfig b/init/Kconfig
index 95ac265..242ce32 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -565,7 +565,7 @@ config COMPAT_BRK
 	  disabled, and can be overriden runtime by setting
 	  /proc/sys/kernel/randomize_va_space to 2.
 
-	  On non-ancient distros (post-2000 ones) Y is usually a safe choice.
+	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
 
 config BASE_FULL
 	default y
