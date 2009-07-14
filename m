Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZGNCR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZGNCR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZGNCR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:17:59 -0400
Received: from senator.holtmann.net ([87.106.208.187]:38317 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZGNCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:17:58 -0400
Subject: Re: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
From: Marcel Holtmann <holtmann@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: tomas.winkler@intel.com, drzeus-list@drzeus.cx, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090713.191001.70978868.davem@davemloft.net>
References: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
	 <20090713.191001.70978868.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 04:17:55 +0200
Message-Id: <1247537875.4549.11.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> From: Tomas Winkler <tomas.winkler@intel.com>
> Date: Tue, 14 Jul 2009 01:09:13 +0300
> 
> > 1. add intel's sdio vendor id to sdio_ids.h
> > 2. move iwmc3200 sdio devices ids to sdio_ids.h
> > 
> > This patch is against 2.6.31-rc2
> > 7638d5322bd89d49e013a03fe2afaeb6d214fabd
> > 
> > Cc:inaky.perez-gonzalez@intel.com
> > Cc:cindy.h.kao@intel.com
> > Cc:samuel.ortiz@intel.com
> > Cc:yi.zhu@intel.com
> > Cc:drzeus-list@drzeus.cx
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> Since wimax stuff goes directly through me and John Linville handles
> wireless things, you're making this overly difficult by combining
> changes for those two subsystems into a single patch.
> 
> Please split this up, thanks.

if Pierre is not afraid of a merge conflict during the next merge window
with the SDIO changes, then I think this should go completely via you. I
am also fine if we just split this up and send one patch to Pierre and
one to you. However since speaking from history, your next tree gets
mostly merged before Pierre's we might producing build errors during the
next merge window.

I can ACK the WiMAX and WiFi changes since both Inaky and Samuel are on
vacation.

Regards

Marcel


