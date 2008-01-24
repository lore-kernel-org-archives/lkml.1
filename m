Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYAXAmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYAXAmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYAXAm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:42:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYAXAmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:42:24 -0500
From: airlied@linux.ie
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       =?utf-8?q?Carlos=20Mart=C3=ADn?= <inean@users.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>
Subject: [PATCH] drm/i915: add support for E7221 chipset
Date: Thu, 24 Jan 2008 10:34:10 +1000
Message-Id: <1201134850-4543-2-git-send-email-airlied@linux.ie>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201134850-4543-1-git-send-email-airlied@linux.ie>
References: <1201134850-4543-1-git-send-email-airlied@linux.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Martín <inean@users.sf.net>

E7221 chipset is a server version of the i915.

Signed-off-by: Dave Airlie <airlied@linux.ie>
---
 drivers/char/drm/drm_pciids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/drm/drm_pciids.h b/drivers/char/drm/drm_pciids.h
index f359397..43d3c42 100644
--- a/drivers/char/drm/drm_pciids.h
+++ b/drivers/char/drm/drm_pciids.h
@@ -297,6 +297,7 @@
 	{0x8086, 0x3582, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x8086, 0x2572, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x8086, 0x2582, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
+	{0x8086, 0x258a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x8086, 0x2592, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x8086, 0x2772, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x8086, 0x27a2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
-- 
1.5.3.6

