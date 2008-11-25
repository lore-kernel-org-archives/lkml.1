Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbYKYPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYKYPYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYKYPXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:23:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:31620 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYKYPW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:22:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dCd/zo2J32PJPxqfeEAe1FsyO9Ru9TxSRw7F+9TEAYhYHkwOm5O36m6nYfVDkUciOu
         SVqPt/7w2gJDUd4mTi+2oqVIgbtXtxH0jrLhkNod3qZ/y/g8tBTAtLuy7NBXUaJTF3pl
         Vbhu8yPUhWMyBnqJSACdTe7jt/AZlO9yfrwbc=
From: "Antonio R. Costa" <costa.antonior@gmail.com>
To: linux@maxim.org.za, nicolas.ferre@atmel.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Antonio R. Costa" <costa.antonior@gmail.com>
Subject: [PATCH 5/5] [RFC PATCH] Support for AT572D940HF-EK [RFC PATCH]
Date: Tue, 25 Nov 2008 16:22:45 +0100
Message-Id: <1227626565-25209-5-git-send-email-costa.antonior@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227626565-25209-4-git-send-email-costa.antonior@gmail.com>
References: <>
 <1227626565-25209-1-git-send-email-costa.antonior@gmail.com>
 <1227626565-25209-2-git-send-email-costa.antonior@gmail.com>
 <1227626565-25209-3-git-send-email-costa.antonior@gmail.com>
 <1227626565-25209-4-git-send-email-costa.antonior@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT572D940HF (Diopsis) is an ARM926 + a 40-bits floating point DSP
(mAgicV)

Reference for machine type:
1783    Atmel DIOPSIS AT572D940HF EK

This RFC patch starts from v2.6.26 because we needed to
test it together with Xenomai 2.4.5.

This patch, if approved, will be rebased to the latest linux kernel.

Shared files in arch/arm and drivers/net

    arch/arm/mach-at91/clock.h

Signed-off-by: Antonio R. Costa <costa.antonior@gmail.com>
---
 arch/arm/mach-at91/clock.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/clock.h b/arch/arm/mach-at91/clock.h
index 0212c37..165fbf5 100644
--- a/arch/arm/mach-at91/clock.h
+++ b/arch/arm/mach-at91/clock.h
@@ -22,7 +22,7 @@ struct clk {
 	struct clk	*parent;
 	u32		pmc_mask;
 	void		(*mode)(struct clk *, int);
-#ifdef ARCH_AT572D940HF
+#ifdef CONFIG_ARCH_AT572D940HF
 	unsigned	id:3;		/* AT572D940HF needs an extra bit */
 #else
 	unsigned	id:2;		/* PCK0..3, or 32k/main/a/b */
-- 
1.5.4.3

