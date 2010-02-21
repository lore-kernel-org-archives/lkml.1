Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab0BUN1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 08:27:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:15946 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0BUN1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 08:27:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QjfYIpS6klvWX7vUczVIH0XMxWzqRb6BE7BOzNOzDC+TGbFVdg7xaZOBWo/staQPuS
         Evy9UHPNeEN1ZgVb8hGhzKgutG73mXuEKROeLzP/e25MZ0ByRTLzhsjbW6PdlIFOTtZ/
         jb/Fhq8tvzlj923uKekd0b7Jqc9uK22pePSf4=
Message-ID: <4B8134EB.2010704@googlemail.com>
Date: Sun, 21 Feb 2010 14:28:11 +0100
From: Frank Schaefer <fschaefer.oss@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: add HPET-quirk for nVidia MCP61 LPC Bridge (10de:03e0)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested with an ASUS M2N-VM DH, which has no BIOS-switch to enable the HPET.

Signed-off-by: Frank Schaefer <fschaefer.oss@googlemail.com>

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 3e914e9..7985ba5 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -468,6 +468,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA,
0x0366,    /* MCP55 */
             nvidia_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0367,    /* MCP55 */
             nvidia_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x03e0,    /* MCP61 */
+            nvidia_force_enable_hpet);
 
 void force_hpet_resume(void)
 {
-- 

