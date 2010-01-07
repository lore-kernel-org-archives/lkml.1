Return-Path: <linux-kernel-owner+w=401wt.eu-S932796Ab0AGA4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab0AGA4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932757Ab0AGA4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:56:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:32856 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932738Ab0AGA4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:56:45 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19E3G4rMVlEwMAWt9BO9rHTvt0HDeL0bhheAvJgCl
	NknasBcm5ST0xy
From: Peter Huewe <PeterHuewe@gmx.de>
To: Marc Singer <elf@buici.com>
Subject: [PATCH] arch/arm: Fix build failure for lpd7a404_defconfig caused by missing includes
Date: Thu, 7 Jan 2010 01:56:35 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001070156.36221.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu, 7 Jan 2010 01:46:49 +0100

This patch fixes a build failure [1] due to missing includes
This should make the arm tree build again with lpd7a404_defconfig

References:
http://kisskb.ellerman.id.au/kisskb/buildresult/1983329/

Patch against Linus' tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/arm/mach-lh7a40x/clocks.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-lh7a40x/clocks.c b/arch/arm/mach-lh7a40x/clocks.c
index fcaf876..0651f96 100644
--- a/arch/arm/mach-lh7a40x/clocks.c
+++ b/arch/arm/mach-lh7a40x/clocks.c
@@ -10,6 +10,8 @@
 #include <mach/hardware.h>
 #include <mach/clocks.h>
 #include <linux/err.h>
+#include <linux/device.h>
+#include <linux/string.h>
 
 struct module;
 
-- 
1.6.4.4

