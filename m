Return-Path: <linux-kernel-owner+w=401wt.eu-S936362AbYD1Pp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936362AbYD1Pp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934242AbYD1PkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:40:07 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59648 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935969AbYD1PkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:40:03 -0400
Date: Mon, 28 Apr 2008 18:39:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mt9{m001,v022}_controls[] static
Message-ID: <20080428153930.GO2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global mt9{m001,v022}_controls[] static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/mt9m001.c |    2 +-
 drivers/media/video/mt9v022.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

d7560162fe24391e091574b08b25ac124369fb7b diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 3fb5f63..04864cf 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -372,7 +372,7 @@ static int mt9m001_set_register(struct soc_camera_device *icd,
 }
 #endif
 
-const struct v4l2_queryctrl mt9m001_controls[] = {
+static const struct v4l2_queryctrl mt9m001_controls[] = {
 	{
 		.id		= V4L2_CID_VFLIP,
 		.type		= V4L2_CTRL_TYPE_BOOLEAN,
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index d4b9e27..597df65 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -452,7 +452,7 @@ static int mt9v022_set_register(struct soc_camera_device *icd,
 }
 #endif
 
-const struct v4l2_queryctrl mt9v022_controls[] = {
+static const struct v4l2_queryctrl mt9v022_controls[] = {
 	{
 		.id		= V4L2_CID_VFLIP,
 		.type		= V4L2_CTRL_TYPE_BOOLEAN,

