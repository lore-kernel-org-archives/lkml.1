Return-Path: <linux-kernel-owner+w=401wt.eu-S1763509AbYGAByv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763509AbYGAByv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYGAByn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:54:43 -0400
Received: from senator.holtmann.net ([87.106.208.187]:54189 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYGAByn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:54:43 -0400
Subject: Re: [PATCH 3/5] MMC: fix sdio_io sparse errors
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <1214869984-20115-3-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 03:54:55 +0200
Message-Id: <1214877295.11537.97.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

>  	if (blksz == 0) {
> -		blksz = min(min(
> -			func->max_blksize,
> -			func->card->host->max_blk_size),
> -			512u);
> +		blksz = min(func->max_blksize, func->card->host->max_blk_size);
> +		blksz = min(blksz, 512u);
>  	}

I agree that your version is more readable, but I would be still
interested in which sparse error this fixes.

Other than that the patch looks good.

Regards

Marcel


