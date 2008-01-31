Return-Path: <linux-kernel-owner+w=401wt.eu-S934329AbYAaV6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329AbYAaV6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933255AbYAaV6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:58:21 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:14513 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060AbYAaV6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:58:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:from;
        b=DYpUve8MGXhD+La47wPIaVmWOiNCkEZmuSQpV/ZSZO1nLc6eMyW766GRLxepOCJIJaRKOb83hJT8nD4D1mBpPh2cTVqAq2k2clnI1BzPbDMPYzM+JmkAZ3XHA133IYmQPUX3S1t6/bZWvn8ElZN7mbScI/YWaEh4vnivE7YVTk8=
Date: Thu, 31 Jan 2008 22:58:11 +0100
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh <linux-sh@vger.kernel.org>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: [PATCH/KCONFIG] - Add SUPERH depends to sound/soc/sh/Kconfig
Message-Id: <20080131225811.a175de2c.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__31_Jan_2008_22_58_11_+0100_T.LFLr8sW.nawaOg"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__31_Jan_2008_22_58_11_+0100_T.LFLr8sW.nawaOg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Currently you will see an empty "SoC Audio support for SuperH" menu 
when building for other archs (example pxa).
This patch adds "depends on SUPERH" to remove that empty menu.

signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/sound/soc/sh/Kconfig b/sound/soc/sh/Kconfig
index f03220d..4c1e013 100644
--- a/sound/soc/sh/Kconfig
+++ b/sound/soc/sh/Kconfig
@@ -1,4 +1,5 @@
 menu "SoC Audio support for SuperH"
+	depends on SUPERH
 
 config SND_SOC_PCM_SH7760
 	tristate "SoC Audio support for Renesas SH7760"


--Multipart=_Thu__31_Jan_2008_22_58_11_+0100_T.LFLr8sW.nawaOg
Content-Type: application/octet-stream;
 name="SoC-SuperH-add-depends.patch"
Content-Disposition: attachment;
 filename="SoC-SuperH-add-depends.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3NvdW5kL3NvYy9zaC9LY29uZmlnIGIvc291bmQvc29jL3NoL0tjb25maWcK
aW5kZXggZjAzMjIwZC4uNGMxZTAxMyAxMDA2NDQKLS0tIGEvc291bmQvc29jL3NoL0tjb25maWcK
KysrIGIvc291bmQvc29jL3NoL0tjb25maWcKQEAgLTEsNCArMSw1IEBACiBtZW51ICJTb0MgQXVk
aW8gc3VwcG9ydCBmb3IgU3VwZXJIIgorCWRlcGVuZHMgb24gU1VQRVJICiAKIGNvbmZpZyBTTkRf
U09DX1BDTV9TSDc3NjAKIAl0cmlzdGF0ZSAiU29DIEF1ZGlvIHN1cHBvcnQgZm9yIFJlbmVzYXMg
U0g3NzYwIgo=

--Multipart=_Thu__31_Jan_2008_22_58_11_+0100_T.LFLr8sW.nawaOg--
