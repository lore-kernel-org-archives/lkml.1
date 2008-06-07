Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbYFGCyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbYFGCyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 22:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYFGCyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 22:54:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:43068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYFGCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 22:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=cEp4nEk6qsj675PolIlFF1Awk7iTEIqguJ1lGuM1cz+6xKnaRwqcXqSK5DTSg+IYNE
         oAllS6O15bXAJnDwOdq6voy+rI3jQZSrIvrF60hMbt99x9PdYjyil3nuRB23KnHz+v0G
         kWqfl5AODmkge2xCMOL9LCaoufsTyQrr11CvE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: 64bit have arch srat
Date: Fri, 6 Jun 2008 19:54:25 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061954.26062.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: 64bit have arch srat

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9ec89..c88784e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -435,7 +435,7 @@ config ACPI_SRAT
 
 config HAVE_ARCH_PARSE_SRAT
 	def_bool y
-	depends on ACPI_SRAT
+	depends on ACPI_SRAT || X86_64
 
 config X86_SUMMIT_NUMA
 	def_bool y
