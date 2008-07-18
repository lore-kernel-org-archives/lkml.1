Return-Path: <linux-kernel-owner+w=401wt.eu-S933259AbYGRAIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbYGRAIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760578AbYGRAIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:08:00 -0400
Received: from www.tglx.de ([62.245.132.106]:37208 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759570AbYGRAH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:07:59 -0400
Date: Fri, 18 Jul 2008 02:07:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert duplicate "ACPI: don't walk tables if ACPI was
 disabled" commit (was: Please pull ACPI updates)
In-Reply-To: <alpine.LFD.1.10.0807180013190.4316@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0807180159270.4316@apollo.tec.linutronix.de>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org> <487EE940.1050007@firstfloor.org>
 <alpine.LFD.1.10.0807170752190.2959@woody.linux-foundation.org> <alpine.LFD.1.10.0807180013190.4316@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Thomas Gleixner wrote:
> 
> Please revert the one I happened to notice. Patch below.

Another one.

Thanks,
 
 	tglx
 
----------->
Subject: APCI: revert another duplicated patch
From: Thomas Gleixner <tglx@linutronix.de>

commit d1857056904d5f313f11184fcfa624652ff9620a

is another superfluous duplicate commit caused by
git -> quilt -> git conversion.

Revert it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de> 

---
diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 6d18ca3..9b227d4 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -336,9 +336,6 @@ static int __init acpi_rtc_init(void)
 	if (acpi_disabled)
 		return 0;
 
-	if (acpi_disabled)
-		return 0;
-
 	if (dev) {
 		rtc_wake_setup();
 		rtc_info.wake_on = rtc_wake_on;
