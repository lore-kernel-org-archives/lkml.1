Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbZKKQxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbZKKQxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZKKQwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:52:55 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37684 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849AbZKKQtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:49:23 -0500
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/17] hpsa: Allocate the correct amount of extra space for
	the scsi host
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
Date: Wed, 11 Nov 2009 10:50:48 -0600
Message-ID: <20091111165048.17754.12645.stgit@beardog.cce.hp.com>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpsa: Allocate the correct amount of extra space for the scsi host

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e402155..85be09c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -890,7 +890,7 @@ static int hpsa_scsi_detect(struct ctlr_info *h)
 	struct Scsi_Host *sh;
 	int error;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(*h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
 	if (sh == NULL)
 		goto fail;
 

