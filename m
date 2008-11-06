Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYKGAAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYKGAAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYKFX74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 18:59:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55838
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbYKFX7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 18:59:55 -0500
Date: Thu, 06 Nov 2008 15:59:54 -0800 (PST)
Message-Id: <20081106.155954.52066801.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-11-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081106224904.GA30233@tuxdriver.com>
References: <20081106224904.GA30233@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 6 Nov 2008 17:49:04 -0500

> Here is the latest round of wireless bits intended for 2.6.28.  It
> includes a revert of an earlier fix that greatly reduced interrupts
> handled by ath5k -- testing showed that it resulted in a greater number
> of dropped associations.
> 
> Also included is an iwlwifi patch ("iwlwifi: clear scanning bits upon
> failure") that is already in -next.  It does not seem to be a strict
> regression, but since it is simple and can leave the device unable to
> scan (i.e. effectively inoperative) I think it is worth having now.
> There are also iwl3945 versions of some iwlwifi fixes as well as an
> iwl3945-specific one related to firmware errors.
> 
> Further, there is a WARN_ON fix for ath5k and another iwlwifi fix from
> me to avoid a possible sleep in softirq context.  Just for fun I've
> thrown-in a couple of zd1211rw USB ID additions as well.

Pulled, thanks a lot John.

> Please let me know if there are problems!  Any mistakes I blame on my
> recent bout of pneumonia...

Hope you feel better soon.
