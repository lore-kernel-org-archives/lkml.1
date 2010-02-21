Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0BUN1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 08:27:37 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42664 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0BUN1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 08:27:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=A2A5sTLJw0KsakbegovKhXCkxsuj069JcjsO/ebYdR3N2JFzqSO1Twa0yB+uI8xTQf
         GpNnrYp3qCMIZs9QPnGbJNnwKpuHz83TaMHme+MkJKQv5mwuhimGAEu8m3+z+/cLlGHu
         ysitosp3WmXBR/Od7B2vCTg6OVAiSnb5UWeLE=
Message-ID: <4B8134E0.2030207@googlemail.com>
Date: Sun, 21 Feb 2010 14:28:00 +0100
From: Frank Schaefer <fschaefer.oss@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: HPET-quirks for nVidia LPC bridges: add model infos
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frank Schaefer <fschaefer.oss@googlemail.com>

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 12e9fea..3e914e9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -450,23 +450,23 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0051,
             nvidia_force_enable_hpet);
 
 /* LPC bridges */
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0260,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0260,    /* MCP51 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0360,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0360,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0361,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0361,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0362,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0362,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0363,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0363,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0364,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0364,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0365,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0365,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0366,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0366,    /* MCP55 */
             nvidia_force_enable_hpet);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0367,
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0367,    /* MCP55 */
             nvidia_force_enable_hpet);
 
 void force_hpet_resume(void)
-- 

