Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZGNCJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZGNCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZGNCJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:09:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53264
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbZGNCJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:09:57 -0400
Date: Mon, 13 Jul 2009 19:10:01 -0700 (PDT)
Message-Id: <20090713.191001.70978868.davem@davemloft.net>
To: tomas.winkler@intel.com
Cc: drzeus-list@drzeus.cx, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] imwc3200: move iwmc3200 SDIO ids to sdio_ids.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
References: <1247522953-12702-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>
Date: Tue, 14 Jul 2009 01:09:13 +0300

> 1. add intel's sdio vendor id to sdio_ids.h
> 2. move iwmc3200 sdio devices ids to sdio_ids.h
> 
> This patch is against 2.6.31-rc2
> 7638d5322bd89d49e013a03fe2afaeb6d214fabd
> 
> Cc:inaky.perez-gonzalez@intel.com
> Cc:cindy.h.kao@intel.com
> Cc:samuel.ortiz@intel.com
> Cc:yi.zhu@intel.com
> Cc:drzeus-list@drzeus.cx
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Since wimax stuff goes directly through me and John Linville handles
wireless things, you're making this overly difficult by combining
changes for those two subsystems into a single patch.

Please split this up, thanks.
