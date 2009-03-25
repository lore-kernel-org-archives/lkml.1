Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZCYAeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZCYAeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbZCYA3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:47 -0400
Received: from kroah.org ([198.145.64.141]:54066 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756784AbZCYA3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-pcmcia@lists.infradead.org
Subject: [PATCH 13/61] pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:17 -0700
Message-Id: <1237940825-22904-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-pcmcia@lists.infradead.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/pcmcia/rsrc_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/rsrc_mgr.c b/drivers/pcmcia/rsrc_mgr.c
index c0e2afc..e592e0e 100644
--- a/drivers/pcmcia/rsrc_mgr.c
+++ b/drivers/pcmcia/rsrc_mgr.c
@@ -153,7 +153,7 @@ static struct resource *iodyn_find_io_region(unsigned long base, int num,
 		unsigned long align, struct pcmcia_socket *s)
 {
 	struct resource *res = make_resource(0, num, IORESOURCE_IO,
-					     s->dev.bus_id);
+					     dev_name(&s->dev));
 	struct pcmcia_align_data data;
 	unsigned long min = base;
 	int ret;
-- 
1.6.2

