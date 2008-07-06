Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbYGFQa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbYGFQa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYGFQaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:30:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:59514 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbYGFQaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=uFEpuJDkhTMoIB2OSv51UK+uI70x0WakcfqqICwGd+EVnce26fGSWjKzXm2AWowqK0
         u7Eb4VenLv4QvobBZvRt2AN49AhLHyySo0JbWChIueBNp87QZjd8PfBm+VMAJPjZjWPD
         Nu87StQ+SvRvWOKRPI6r+wZVXvODB6pXINM8Q=
Message-ID: <a4423d670807060930p73465b1bj9c2e4eea01fb5b7a@mail.gmail.com>
Date: Sun, 6 Jul 2008 20:30:12 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: jgarzik@pobox.com, netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/cs89x0.c: remove unnecessary includes.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

The patch applies to the linux-next tree.

drivers/net/cs89x0.c: remove unnecessary includes.
asm/irq.h is already included unconditionally at 151 string.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

diff --git a/drivers/net/cs89x0.c b/drivers/net/cs89x0.c
index fba87ab..5a9d118 100644
--- a/drivers/net/cs89x0.c
+++ b/drivers/net/cs89x0.c
@@ -182,13 +182,10 @@ static unsigned int cs8900_irq_map[] = {1,0,0,0};
 #elif defined(CONFIG_MACH_IXDP2351)
 static unsigned int netcard_portlist[] __used __initdata =
{IXDP2351_VIRT_CS8900_BASE, 0};
 static unsigned int cs8900_irq_map[] = {IRQ_IXDP2351_CS8900, 0, 0, 0};
-#include <asm/irq.h>
 #elif defined(CONFIG_ARCH_IXDP2X01)
-#include <asm/irq.h>
 static unsigned int netcard_portlist[] __used __initdata =
{IXDP2X01_CS8900_VIRT_BASE, 0};
 static unsigned int cs8900_irq_map[] = {IRQ_IXDP2X01_CS8900, 0, 0, 0};
 #elif defined(CONFIG_ARCH_PNX010X)
-#include <asm/irq.h>
 #include <asm/arch/gpio.h>
 #define CIRRUS_DEFAULT_BASE    IO_ADDRESS(EXT_STATIC2_s0_BASE +
0x200000)      /* = Physical address 0x48200000 */
 #define CIRRUS_DEFAULT_IRQ     VH_INTC_INT_NUM_CASCADED_INTERRUPT_1
/* Event inputs bank 1 - ID 35/bit 3 */
