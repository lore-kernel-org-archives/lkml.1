Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbZEFPR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbZEFPR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760059AbZEFPRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:17:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54967 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756336AbZEFPRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:17:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] uml: UML net driver does not allow for vlans
To: jdike@addtoit.com, linux-kernel@vger.kernel.org
Date: Wed, 06 May 2009 17:16:27 +0100
Message-ID: <20090506161616.24491.69282.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See ancient discussion at
http://marc.info/?l=user-mode-linux-devel&m=101990155831279&w=2

and BUG #7854

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/um/include/shared/net_user.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/um/include/shared/net_user.h b/arch/um/include/shared/net_user.h
index 63bee15..3dabbe1 100644
--- a/arch/um/include/shared/net_user.h
+++ b/arch/um/include/shared/net_user.h
@@ -8,7 +8,7 @@
 
 #define ETH_ADDR_LEN (6)
 #define ETH_HEADER_ETHERTAP (16)
-#define ETH_HEADER_OTHER (14)
+#define ETH_HEADER_OTHER (26) /* 14 for ethernet + VLAN + MPLS for crazy people */
 #define ETH_MAX_PACKET (1500)
 
 #define UML_NET_VERSION (4)

