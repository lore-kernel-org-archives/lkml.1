Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbYHEVig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbYHEVig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYHEVi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:38:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:25077 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYHEVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nbYUW0DpISCvHOpqUqWi/IKltR69UgKk2qVx0e70UtG0UeT4CSYAcKfJ6X40B9NTDT
         xwxpd06vb+LJL3zwTPyRgbOtPjJyk+r0nhxuUZ4YJ3iNB2LF+HXrR9NAbQgkjuiMfRVv
         BwecyrCYwTgoFORaGCdMTokJ+AGNSAQkjpUtU=
Date: Wed, 6 Aug 2008 01:31:11 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] saa7134-core.c: fix warning
Message-ID: <20080805213111.GA17627@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

saa7134-core.c: fix warning

drivers/media/video/saa7134/saa7134-core.c:366: warning:
'saa7134_buffer_requeue' defined but not used

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/media/video/saa7134/saa7134-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 75d6184..0473a79 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -360,7 +360,7 @@ void saa7134_buffer_timeout(unsigned long data)
 }
 
 /* resends a current buffer in queue after resume */
-
+#ifdef CONFIG_PM
 static int saa7134_buffer_requeue(struct saa7134_dev *dev,
 				  struct saa7134_dmaqueue *q)
 {
@@ -384,7 +384,7 @@ static int saa7134_buffer_requeue(struct saa7134_dev *dev,
 
 	return 0;
 }
-
+#endif
 /* ------------------------------------------------------------------ */
 
 int saa7134_set_dmabits(struct saa7134_dev *dev)
