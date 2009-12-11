Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbZLKPAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbZLKPAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZLKPAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:00:18 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49270 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZLKPAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:00:17 -0500
Date: Fri, 11 Dec 2009 09:54:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
       wey-yi.w.guy@intel.com
Subject: Re: [PATCH] Fix iwl typo
Message-ID: <20091211145420.GB6663@tuxdriver.com>
References: <20091211114054.GZ8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211114054.GZ8742@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:40:54PM +0100, Jens Axboe wrote:
> Hi,
> 
> I came across this one:
> 
> drivers/net/wireless/iwlwifi/iwl-tx.c: In function ?iwl_tx_agg_stop?:
> drivers/net/wireless/iwlwifi/iwl-tx.c:1356: warning: passing argument 1
> of ?ieee80211_stop_tx_ba_cb_irqsafe? from incompatible pointer type
> include/net/mac80211.h:2128: note: expected ?struct ieee80211_vif *? but
> argument is of type ?struct ieee80211_hw *?
> 
> which just looks like a simple typo, priv->hw should be priv->vif.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

A patch like this is already in net-2.6.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
