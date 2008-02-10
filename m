Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbYBJQ35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbYBJQ35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 11:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYBJQ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 11:29:46 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:56096 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYBJQ3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 11:29:45 -0500
X-Greylist: delayed 1349 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2008 11:29:44 EST
Date: Mon, 11 Feb 2008 01:07:29 +0900 (JST)
Message-Id: <20080211.010729.115910395.anemo@mba.ocn.ne.jp>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] ide: add struct ide_port_info instances to legacy
 host drivers
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080106170310.6861.14522.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
	<20080106170310.6861.14522.sendpatchset@localhost.localdomain>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jan 2008 18:03:10 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> +	/* reset DMA masks only for SFF-style DMA controllers */
> +	if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
> +		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;

It might be too late, but "host_flags && IDE_HFLAGS_NO_DMA" seems
wrong for me.

---
Atsushi Nemoto
