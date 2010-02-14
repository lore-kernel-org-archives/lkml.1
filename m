Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab0BNLgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 06:36:41 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:62715 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab0BNLgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 06:36:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RfGEsrKGF/WKNAkRprS1xEZ1F5/lgPjzAgGepQvjkutPOEdcGbwTlu+Y91h2cHlJwz
         LBTkpEnA9W9EiXhz+WYbQixR92Fv2UzWsVwtjIlilhsIBet+zsv3Oo1yEFQT6oBWkjV6
         F5f/gb+GUy0Nnv53BBlXlNe+DEa0BuVGaDKKU=
Message-ID: <4B77E021.3030409@googlemail.com>
Date: Sun, 14 Feb 2010 12:36:01 +0100
From: Frank Schaefer <fschaefer.oss@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add HPET-quirk for nVidia MCP61 LPC Bridge rev a2 (10de:03e0)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested with an ASUS M2N-VM DH, which has no BIOS-switch to enable the HPET.

Signed-off-by: Frank Schaefer <fschaefer.oss@googlemail.com>
Cc: stable@kernel.org

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 12e9fea..28ce845 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -468,6 +468,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0366,
 			nvidia_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0367,
 			nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x03e0,
+			nvidia_force_enable_hpet);
 
 void force_hpet_resume(void)
 {
-- 

