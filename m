Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYFIX7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYFIX7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYFIX7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:59:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:14252 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYFIX7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ItB6qXwhak5IqMToz8uy8IGWSIfv2C5eDozKK1iJ9iFHaEg2oLyu6OGLLKT9WDJKSg
         WIm/qOCgBzjMItzQ+RLBwp25zTIJzj8nz61SwBanDlUgiIRViXhdm8TZRUIdsG9OZNDI
         vngLsKksJI9EXZLOUsuIYuyAilsI5FyaRCa1k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: make generic arch support NUMAQ - fix
Date: Mon, 9 Jun 2008 17:00:15 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806050309.11197.yhlu.kernel@gmail.com> <200806070031.35322.yhlu.kernel@gmail.com> <200806081831.54869.yhlu.kernel@gmail.com>
In-Reply-To: <200806081831.54869.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091700.15772.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix typo in bigsmp switching

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index ba18dec..5a7e461 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -64,7 +64,7 @@ early_param("apic", parse_apic);
 
 void __init generic_bigsmp_probe(void)
 {
-#if CONFIG_X86_BIGSMP
+#ifdef CONFIG_X86_BIGSMP
 	/*
 	 * This routine is used to switch to bigsmp mode when
 	 * - There is no apic= option specified by the user
