Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbZDFWN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbZDFWN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZDFWMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:12:51 -0400
Received: from gw.goop.org ([64.81.55.164]:33969 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbZDFWMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:12:50 -0400
Message-ID: <49DA7E18.1050209@goop.org>
Date: Mon, 06 Apr 2009 15:11:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] early-quirks: remove duplicate #ifdef
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)" was repeated
twice.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index ebdb85c..76b8cd9 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -97,7 +97,6 @@ static void __init nvidia_bugs(int num, int slot, int func)
 }
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
-#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -115,7 +114,6 @@ static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 	d &= 0xff;
 	return d;
 }
-#endif
 
 static void __init ati_bugs(int num, int slot, int func)
 {


