Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXGUO1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXGUO1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXGUO0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:26:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53401 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbXGUO0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:26:50 -0400
Date: Sun, 22 Jul 2007 00:27:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       sparclinux@vger.kernel.org, paulus@samba.org,
       "David S. Miller" <davem@davemloft.net>, wli@holomorphy.com
Subject: [PATCH] constify of_platform_driver match_table
Message-Id: <20070722002701.77622474.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/of_platform.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Built for PowerPC allmodconfig and ppc64_defconfig and Sparc and Sparc64
defconfig.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 22c3837..448f70b 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -32,7 +32,7 @@ extern struct bus_type of_platform_bus_type;
 struct of_platform_driver
 {
 	const char		*name;
-	struct of_device_id	*match_table;
+	const struct of_device_id	*match_table;
 	struct module		*owner;
 
 	int	(*probe)(struct of_device* dev,
-- 
1.5.2.3

