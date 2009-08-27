Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZH0Oiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZH0Oiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZH0Oiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:38:54 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:52966 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZH0Oix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:38:53 -0400
Date: Thu, 27 Aug 2009 23:33:54 +0900 (JST)
Message-Id: <20090827.233354.232970031.anemo@mba.ocn.ne.jp>
To: nicolas.ferre@atmel.com
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com, haavard.skinnemoen@atmel.com,
       pierre@ossman.eu
Subject: Re: [PATCH] dmaengine: Move all map_sg/unmap_sg for slave channel
 to its client
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4A940E9A.8010807@atmel.com>
References: <1249012788-965-1-git-send-email-anemo@mba.ocn.ne.jp>
	<4A940E9A.8010807@atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 18:17:30 +0200, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > Dan Williams wrote:
> > ... DMA-slave clients request specific channels and know the hardware
> > details at a low level, so it should not be too high an expectation to
> > push dma mapping responsibility to the client.
> > 
> > Also this patch includes DMA_COMPL_{SRC,DEST}_UNMAP_SINGLE support for
> > dw_dmac driver.
> > 
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
> I have tested it and it is ok.
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thank you for testing and good news!

---
Atsushi Nemoto
