Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYKWTTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYKWTTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYKWTTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:19:36 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:7659 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYKWTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:19:35 -0500
Message-ID: <154e089b0811231119s2c91de2md3144ff9ed2d73f7@mail.gmail.com>
Date: Sun, 23 Nov 2008 20:19:33 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: HPET: fix sparse warning
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:

arch/x86/kernel/hpet.c:36:18: warning: symbol 'hpet_num_timers' was
not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 067d8de..15fcaac 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -33,7 +33,7 @@
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long				hpet_address;
-unsigned long				hpet_num_timers;
+static unsigned long			hpet_num_timers;
 static void __iomem			*hpet_virt_address;

 struct hpet_dev {
