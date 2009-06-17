Return-Path: <linux-kernel-owner+w=401wt.eu-S1760401AbZFQVob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbZFQVob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZFQVoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:44:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:48915 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZFQVoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:44:23 -0400
Message-ID: <4A396384.5030703@kernel.org>
Date: Wed, 17 Jun 2009 14:43:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: mce fix type
References: <4A396361.2000302@kernel.org>
In-Reply-To: <4A396361.2000302@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


can not have two ignore_ce

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1777,7 +1777,7 @@ static struct sysdev_ext_attribute attr_
 };
 
 static struct sysdev_ext_attribute attr_cmci_disabled = {
-	_SYSDEV_ATTR(ignore_ce, 0644, sysdev_show_int, set_cmci_disabled),
+	_SYSDEV_ATTR(cmci_disabled, 0644, sysdev_show_int, set_cmci_disabled),
 	&mce_cmci_disabled
 };
 
