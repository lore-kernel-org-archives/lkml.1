Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZJLW4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZJLW4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758583AbZJLW4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:56:46 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:56558 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582AbZJLW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:56:45 -0400
To: Vipin Bhandari <vipin.bhandari@ti.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       akpm@linux-foundation.org, drzeus-mmc@drzeus.cx
Subject: Re: [PATCH] DaVinci: MMC: MMC/SD controller driver for DaVinci family
References: <1254427155-26532-1-git-send-email-vipin.bhandari@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 12 Oct 2009 15:50:55 -0700
In-Reply-To: <1254427155-26532-1-git-send-email-vipin.bhandari@ti.com> (Vipin Bhandari's message of "Thu\,  1 Oct 2009 15\:59\:15 -0400")
Message-ID: <877hv0ql9s.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vipin Bhandari <vipin.bhandari@ti.com> writes:

> This patch adds support for MMC/SD controller driver for all DaVinci family
> SoC. This patch supports davinci family SoC's DM6446, DM355, DM365 and
> DA830/OMAPL137.
>
> The patch has been tested on DM355 EVM.
>
> The MMCSD controller specifications for DM355 can be found at
> http://focus.ti.com/general/docs/litabsmultiplefilelist.tsp?literatureNumber=spruee2c
>
> Signed-off-by: Vipin Bhandari <vipin.bhandari@ti.com>
> Signed-off-by: Purshotam Kumar <purushotam@ti.com>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Vipin,

In addition to this, I've also been carrying the diff below in DaVinci
git.  Is this change still necessary?

Kevin


diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index fe8f613..6c76f64 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -178,7 +178,7 @@ struct mmc_davinci_host {
 	u32 buffer_bytes_left;
 	u32 bytes_left;
 
-	u8 rxdma, txdma;
+	u32 rxdma, txdma;
 	bool use_dma;
 	bool do_dma;
 
@@ -190,7 +190,7 @@ struct mmc_davinci_host {
 	struct edmacc_param	tx_template;
 	struct edmacc_param	rx_template;
 	unsigned		n_link;
-	u8			links[NR_SG - 1];
+	u32			links[NR_SG - 1];
 
 	/* For PIO we walk scatterlists one segment at a time. */
 	unsigned int		sg_len;
