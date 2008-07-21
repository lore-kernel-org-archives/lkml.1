Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYGUSW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYGUSW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYGUSWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:22:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:60749 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYGUSWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QVF1rQRZfpjBTxCNWz/Ogri1eBGOPpqgMCqlc2jF0K7HiSTb4IPcoCHxT0RjYTqe/A
         Wnpqr9MU8XjYm5g5u9p2tzOpfIMx9pijKFbHYCOL8NyTxv7/YghIn4twTdYCVf7vXKeq
         kQDcFyrX5VSPLmhyfK3CqrE14hUeyoDJvvt0o=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: use setup_clear_cpu_cap with disable_apic -fix
Date: Mon, 21 Jul 2008 11:21:43 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807210138.15054.yhlu.kernel@gmail.com>
In-Reply-To: <200807210138.15054.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211121.44464.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -680,7 +680,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_LOCAL_APIC
 		disable_apic = 1;
 #endif
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+		setup_clear_cpu_cap(X86_FEATURE_APIC);
 	}
 
 #ifdef CONFIG_PCI
