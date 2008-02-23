Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYBWQVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYBWQVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYBWQVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:21:41 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:51863 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYBWQVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:21:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Subject: Re: [PATCH] Fix the bcm43xx driver breakage in 2.6.24/25.
Date: Sat, 23 Feb 2008 17:20:21 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Jeff Garzik <jgarzik@pobox.com>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <47C01D03.9030601@gmail.com>
In-Reply-To: <47C01D03.9030601@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802231720.21920.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008 14:17:55 Alexey Zaytsev wrote:
> diff --git a/drivers/net/wireless/bcm43xx/Kconfig b/drivers/net/wireless/bcm43xx/Kconfig
> index 0159701..afb8f43 100644
> --- a/drivers/net/wireless/bcm43xx/Kconfig
> +++ b/drivers/net/wireless/bcm43xx/Kconfig
> @@ -1,6 +1,6 @@
>  config BCM43XX
>  	tristate "Broadcom BCM43xx wireless support (DEPRECATED)"
> -	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
> +	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && (!SSB_B43_PCI_BRIDGE || SSB != y) && EXPERIMENTAL

so if SSB is m it will break module auto-loading, right?

-- 
Greetings Michael.
