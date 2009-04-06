Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZDFCPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZDFCPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 22:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZDFCOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 22:14:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:61911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZDFCOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 22:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NfhQKE98WS3QJ3j2UZh6dNTmVNlSYn9VHNvUqC1cozZq+sobKxLu0oRTvGUNDOPlqF
         7N40HmEIQLCZqpbT+/YTZ2yuVaBZroy1844G8CEaIQPEgTpXgmRP8avIgH1BknUEJ7YK
         bQYYD+odsbgq0kLjev7AZrI4VXai5zUuvIf40=
Date: Mon, 6 Apr 2009 06:14:43 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] au0828: fix Kconfig dependance
Message-ID: <20090406021443.GA21068@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
ERROR: "videobuf_queue_vmalloc_init" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "videobuf_vmalloc_free" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "videobuf_to_vmalloc" [drivers/media/video/au0828/au0828.ko] undefined!

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/media/video/au0828/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/au0828/Kconfig b/drivers/media/video/au0828/Kconfig
index 05cdf49..0c3a5ba 100644
--- a/drivers/media/video/au0828/Kconfig
+++ b/drivers/media/video/au0828/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_AU0828
 	depends on I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
+	select VIDEOBUF_VMALLOC
 	select DVB_AU8522 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
