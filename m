Return-Path: <linux-kernel-owner+w=401wt.eu-S1762371AbZBYV3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762371AbZBYV3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761963AbZBYV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:29:23 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:41784 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761941AbZBYV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:29:22 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 5/7] sound/drivers/vx: fix sparse warning: different signedness
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 22:29:15 +0100
Message-ID: <20090225212907.9226.10636.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
References: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  sound/drivers/vx/vx_uer.c:301:42: warning: incorrect type in argument 2 (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/drivers/vx/vx_uer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/drivers/vx/vx_uer.c b/sound/drivers/vx/vx_uer.c
index 0e1ba9b..b0560fe 100644
--- a/sound/drivers/vx/vx_uer.c
+++ b/sound/drivers/vx/vx_uer.c
@@ -103,7 +103,7 @@ static void vx_write_one_cbit(struct vx_core *chip, int index, int val)
  * returns the frequency of UER, or 0 if not sync,
  * or a negative error code.
  */
-static int vx_read_uer_status(struct vx_core *chip, int *mode)
+static int vx_read_uer_status(struct vx_core *chip, unsigned int *mode)
 {
 	int val, freq;
 

