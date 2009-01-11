Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbZAKPHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbZAKPHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZAKPHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:07:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZAKPHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:07:09 -0500
Subject: Re: Build error on latest git
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Petr Titera <P.Titera@century.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <496A080B.30609@century.cz>
References: <4969C096.9060909@century.cz> <4969DEA0.5020301@century.cz>
	 <3f9a31f40901110506v646bd599q863be03accbfd8b2@mail.gmail.com>
	 <1231679335.3244.1.camel@jaswinder.satnam>  <496A080B.30609@century.cz>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 20:34:47 +0530
Message-Id: <1231686287.3370.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 15:54 +0100, Petr Titera wrote:
> Hmm that was my first try to fix this. But unfortunatelly it fails in 
> arch/x86/kernel/apic.c right after that.
> 

Ingo, please also apply this to x86/urgent

Subject: [PATCH] x86: fix apic.c build error on latest git

Fix this by reintroducing asm/smp.h include in apic.c - later on
I will fix this by removing non-smp data from smp.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index d2d17b8..b1fd8f6 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -48,6 +48,7 @@
 #include <asm/proto.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/smp.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
-- 
1.5.6.6




