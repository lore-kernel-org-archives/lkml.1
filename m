Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbXGUOXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbXGUOXN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbXGUOW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:22:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60339 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbXGUOWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:22:55 -0400
Date: Sun, 22 Jul 2007 00:23:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       sparclinux@vger.kernel.org, paulus@samba.org,
       "David S. Miller" <davem@davemloft.net>, wli@holomorphy.com
Subject: [PATCH] constify of_platform_driver name
Message-Id: <20070722002303.df29f666.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/pcmcia/m8xx_pcmcia.c |    2 +-
 include/linux/of_platform.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Built for PowerPC allmodconfig and ppc64_defconfig, and for Sparc and
Sparc64 defconfig.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 3c45142..b019854 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -1316,7 +1316,7 @@ static struct of_device_id m8xx_pcmcia_match[] = {
 MODULE_DEVICE_TABLE(of, m8xx_pcmcia_match);
 
 static struct of_platform_driver m8xx_pcmcia_driver = {
-	.name = (char *)driver_name,
+	.name = driver_name,
 	.match_table = m8xx_pcmcia_match,
 	.probe = m8xx_probe,
 	.remove = m8xx_remove,
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 5fd44e6..22c3837 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -31,7 +31,7 @@ extern struct bus_type of_platform_bus_type;
  */
 struct of_platform_driver
 {
-	char			*name;
+	const char		*name;
 	struct of_device_id	*match_table;
 	struct module		*owner;
 
-- 
1.5.2.3

