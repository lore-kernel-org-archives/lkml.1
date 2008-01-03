Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbYACPrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbYACPrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYACPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:48634 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbYACPm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:28 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH x86] [13/16] i386: Set CFQ as default in i386 defconfig
Message-Id: <20080103154227.784F114DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Someone complained that the i386 defconfig contains AS as default IO
scheduler. Change that to CFQ.

Cc: axboe@kernel.dk

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/configs/i386_defconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/configs/i386_defconfig
===================================================================
--- linux.orig/arch/x86/configs/i386_defconfig
+++ linux/arch/x86/configs/i386_defconfig
@@ -99,9 +99,9 @@ CONFIG_IOSCHED_NOOP=y
 CONFIG_IOSCHED_AS=y
 CONFIG_IOSCHED_DEADLINE=y
 CONFIG_IOSCHED_CFQ=y
-CONFIG_DEFAULT_AS=y
+# CONFIG_DEFAULT_AS is not set
 # CONFIG_DEFAULT_DEADLINE is not set
-# CONFIG_DEFAULT_CFQ is not set
+CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
 
