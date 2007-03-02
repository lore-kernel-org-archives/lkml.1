Return-Path: <linux-kernel-owner+w=401wt.eu-S2992426AbXCBN2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992426AbXCBN2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXCBN2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:28:12 -0500
Received: from smtp.nokia.com ([131.228.20.172]:30538 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992426AbXCBN2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:28:12 -0500
Subject: [RFC] [PATCH] Kconfig: enlarge printk buffer size limit
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:27:48 +0200
Message-Id: <1172842068.17031.55.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Mar 2007 13:27:48.0656 (UTC) FILETIME=[920AFB00:01C75CCE]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070302152808-4BCD4BB0-35A45573/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@nokia.com>
Subject: [RFC] [PATCH] Kconfig: enlarge printk buffer size limit

This patch makes the upper kernel ring buffer size limit larger. It
is often very handy to have huge ring-buffer for debugging purposes,
when the subsystem which is being debugged produces large amount of
useful output.

Index: ubi-2.6.git/lib/Kconfig.debug
===================================================================
--- ubi-2.6.git.orig/lib/Kconfig.debug
+++ ubi-2.6.git/lib/Kconfig.debug
@@ -79,7 +79,7 @@ config DEBUG_KERNEL
 
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)" if DEBUG_KERNEL
-	range 12 21
+	range 12 26
 	default 17 if S390 || LOCKDEP
 	default 16 if X86_NUMAQ || IA64
 	default 15 if SMP



