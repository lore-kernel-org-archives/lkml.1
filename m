Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbZJMFeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbZJMFeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZJMFeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:34:06 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:57174 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZJMFeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:34:05 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] ehci-hcd: Fix typo in an error message
Date: Tue, 13 Oct 2009 08:37:09 +0300
Message-Id: <1255412229-5996-1-git-send-email-ozan@pardus.org.tr>
X-Mailer: git-send-email 1.6.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct word is handshake.

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 drivers/usb/host/ehci-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 9835e07..a68eb2c 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -209,7 +209,7 @@ static int handshake_on_error_set_halt(struct ehci_hcd *ehci, void __iomem *ptr,
 	if (error) {
 		ehci_halt(ehci);
 		ehci_to_hcd(ehci)->state = HC_STATE_HALT;
-		ehci_err(ehci, "force halt; handhake %p %08x %08x -> %d\n",
+		ehci_err(ehci, "force halt; handshake %p %08x %08x -> %d\n",
 			ptr, mask, done, error);
 	}
 
-- 
1.6.4.4

