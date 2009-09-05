Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZIELY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZIELY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 07:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZIELYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 07:24:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:53435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbZIELYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 07:24:24 -0400
Subject: [PATCH] x86: Fix 20 section mismatch warnings from x86_init,
 arch/x86/kernel/x86_init.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1252149270.4969.6.camel@ht.satnam>
References: <1252149270.4969.6.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 16:50:41 +0530
Message-Id: <1252149641.4969.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Check http://marc.info/?l=linux-kernel&m=125214951924366&w=2 to see more details.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/x86_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 24be7f3..81dd9d0 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -23,7 +23,7 @@ void __init x86_init_pgd_noop(pgd_t *unused) { }
  * The platform setup functions are preset with the default functions
  * for standard PC hardware.
  */
-struct __initdata x86_init_ops x86_init = {
+struct __initdata x86_init_ops x86_init_ops = {
 
 	.resources = {
 		.probe_roms		= x86_init_noop,
-- 
1.6.0.6


