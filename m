Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZLMX5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZLMX5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZLMX5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbZLMX5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:47 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org
Subject: [PATCH 5/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:33 +0100
Message-Id: <a7c443516914d21204d6df177013bfd804186869.1260662997.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662997.git.re.emese@gmail.com>
References: <cover.1260662997.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/media/dvb/dvb-core/dvbdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 94159b9..9684961 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -191,6 +191,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			const struct dvb_device *template, void *priv, int type)
 {
 	struct dvb_device *dvbdev;
+	/* cannot be const, see this function */
 	struct file_operations *dvbdevfops;
 	struct device *clsdev;
 	int minor;
-- 
1.6.5.3

