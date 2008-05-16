Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbYEPXys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbYEPXys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbYEPXyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:54:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbYEPXx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:53:56 -0400
Date: Fri, 16 May 2008 16:53:51 -0700 (PDT)
Message-Id: <20080516.165351.167152692.davem@davemloft.net>
To: sparclinux@vger.kernel.org
CC: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2]: sparc64: Add missing hypervisor service group numbers.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/kernel/hvapi.c      |    4 ++++
 include/asm-sparc64/hypervisor.h |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/sparc64/kernel/hvapi.c b/arch/sparc64/kernel/hvapi.c
index f34f5d6..691760b 100644
--- a/arch/sparc64/kernel/hvapi.c
+++ b/arch/sparc64/kernel/hvapi.c
@@ -34,8 +34,12 @@ static struct api_info api_table[] = {
 	{ .group = HV_GRP_LDOM,					},
 	{ .group = HV_GRP_SVC_CHAN,	.flags = FLAG_PRE_API	},
 	{ .group = HV_GRP_NCS,		.flags = FLAG_PRE_API	},
+	{ .group = HV_GRP_RNG,					},
 	{ .group = HV_GRP_NIAG_PERF,	.flags = FLAG_PRE_API	},
 	{ .group = HV_GRP_FIRE_PERF,				},
+	{ .group = HV_GRP_N2_CPU,				},
+	{ .group = HV_GRP_NIU,					},
+	{ .group = HV_GRP_VF_CPU,				},
 	{ .group = HV_GRP_DIAG,		.flags = FLAG_PRE_API	},
 };
 
diff --git a/include/asm-sparc64/hypervisor.h b/include/asm-sparc64/hypervisor.h
index 3ad45df..f4fea2e 100644
--- a/include/asm-sparc64/hypervisor.h
+++ b/include/asm-sparc64/hypervisor.h
@@ -2920,8 +2920,12 @@ extern unsigned long sun4v_ncs_request(unsigned long request,
 #define HV_GRP_LDOM			0x0101
 #define HV_GRP_SVC_CHAN			0x0102
 #define HV_GRP_NCS			0x0103
+#define HV_GRP_RNG			0x0104
 #define HV_GRP_NIAG_PERF		0x0200
 #define HV_GRP_FIRE_PERF		0x0201
+#define HV_GRP_N2_CPU			0x0202
+#define HV_GRP_NIU			0x0204
+#define HV_GRP_VF_CPU			0x0205
 #define HV_GRP_DIAG			0x0300
 
 #ifndef __ASSEMBLY__
-- 
1.5.5.1.57.g5909c

