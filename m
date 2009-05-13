Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbZEMWD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbZEMWD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbZEMWDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:03:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:56685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZEMWDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:03:17 -0400
Subject: [PATCH 2/2] x86: apic/apic.c native_apic_write_dummy() should be
 static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
In-Reply-To: <1242251841.3364.17.camel@localhost.localdomain>
References: <1242251841.3364.17.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 03:29:33 +0530
Message-Id: <1242251973.3364.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d6d4ffd..966783b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -243,7 +243,7 @@ static int modern_apic(void)
  * bare function to substitute write operation
  * and it's _that_ fast :)
  */
-void native_apic_write_dummy(u32 reg, u32 v)
+static void native_apic_write_dummy(u32 reg, u32 v)
 {
 	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
 }
-- 
1.6.0.6



