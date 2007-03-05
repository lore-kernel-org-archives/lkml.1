Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXCECpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXCECpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXCECpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:45:15 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45439 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXCECpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:45:14 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 5 Mar 2007 03:44:52 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: ohci1394: add reg_flush, remove bogus barriers
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.d79e708fd3f5b582@s5r6.in-berlin.de>
Message-ID: <tkrat.c70ebf03a060487a@s5r6.in-berlin.de>
References: <tkrat.d79e708fd3f5b582@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> @@ -1521,7 +1513,7 @@ static int ohci_iso_recv_start(struct hp
>  
>  	if (sync != -1) {
>  		/* set sync flag on first DMA descriptor */
> -		struct dma_cmd *cmd = &recv->block[recv->block_dma];
> + 		struct dma_cmd *cmd = &recv->block[recv->block_dma];
>  		cmd->control |= cpu_to_le32(DMA_CTL_WAIT);
>  
>  		/* match sync field */

Ignore this hunk.
-- 
Stefan Richter
-=====-=-=== --== --=-=
http://arcgraph.de/sr/

