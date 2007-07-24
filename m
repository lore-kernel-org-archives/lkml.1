Return-Path: <linux-kernel-owner+w=401wt.eu-S934880AbXGXIzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880AbXGXIzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763150AbXGXIzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:55:17 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48319 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760025AbXGXIzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:55:16 -0400
Date: Tue, 24 Jul 2007 12:55:40 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
Subject: [PATCH 1/8] dm: Add missing 'kfree' to dm-crypt target constructor.
Message-ID: <20070724085540.GA16507@dnb.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-crypt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cdd3f2c..1315002 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -175,6 +175,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 
 	if (err) {
 		ti->error = "Error calculating hash in ESSIV";
+		kfree(salt);
 		return err;
 	}
 
-- 
1.5.2.2


