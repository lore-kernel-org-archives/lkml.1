Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXJGTkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXJGTkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbXJGTkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:40:07 -0400
Received: from saeurebad.de ([85.214.36.134]:41960 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbXJGTkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:40:05 -0400
X-Greylist: delayed 1270 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Oct 2007 15:40:05 EDT
Date: Sun, 7 Oct 2007 21:18:49 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org
Subject: [TRIVIAL PATCH] Remove unused variable in drivers/dma/ioatdma.c
Message-ID: <20071007191849.GA30018@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found this in an `allyesconfig' build:

  CC      drivers/dma/ioatdma.o
  drivers/dma/ioatdma.c: In function #ioat_dma_free_chan_resources#:
  drivers/dma/ioatdma.c:247: warning: unused variable #chanctrl#

	Hannes

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index 41b18c5..d9db64b 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -244,7 +244,6 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
 	struct ioat_device *ioat_device = to_ioat_device(chan->device);
 	struct ioat_desc_sw *desc, *_desc;
-	u16 chanctrl;
 	int in_use_descs = 0;
 
 	ioat_dma_memcpy_cleanup(ioat_chan);
