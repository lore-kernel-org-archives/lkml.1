Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYACPrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYACPrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYACPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbYACPm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:29 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH x86] [14/16] Enable RDC321X subarch only on 32bit
Message-Id: <20080103154228.875B814DDD@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -295,6 +295,7 @@ config X86_RDC321X
 	select X86_REBOOTFIXUPS
 	select GENERIC_GPIO
 	select LEDS_GPIO
+	depends on X86_32
 	help
 	  This option is needed for RDC R-321x system-on-chip, also known
 	  as R-8610-(G).
