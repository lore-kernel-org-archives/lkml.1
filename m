Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbXJZOwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbXJZOwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJZOwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:52:44 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:34746 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbXJZOwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:52:43 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: [PATCH] [LXFB] Use the correct MSR number for panel support
To: linux-fbdev-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, tibor.osztodi@bbraun.com,
       linux-info@geode.amd.com
Date: Fri, 26 Oct 2007 08:53:01 -0600
Message-ID: <20071026145301.14168.19412.stgit@cosmic.amd.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Oct 2007 14:52:25.0595 (UTC)
 FILETIME=[D272E4B0:01C817DF]
X-WSS-ID: 6B3F20A32IW283342-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jordan Crouse <jordan.crouse@amd.com>

A relatively recent version of the Geode LX datasheet listed the wrong
address for one of the MSRs that controls TFT panels, resulting in 
breakage.  This patch corrects the MSR address.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
---

 drivers/video/geode/lxfb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
index 6c227f9..ca13c48 100644
--- a/drivers/video/geode/lxfb.h
+++ b/drivers/video/geode/lxfb.h
@@ -33,7 +33,7 @@ void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
 
 #define MSR_LX_GLD_CONFIG    0x48002001
 #define MSR_LX_GLCP_DOTPLL   0x4c000015
-#define MSR_LX_DF_PADSEL     0x48000011
+#define MSR_LX_DF_PADSEL     0x48002011
 #define MSR_LX_DC_SPARE      0x80000011
 #define MSR_LX_DF_GLCONFIG   0x48002001
 



