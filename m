Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYD3FbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYD3FbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 01:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbYD3Fa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 01:30:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57390
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756777AbYD3Faz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 01:30:55 -0400
Date: Tue, 29 Apr 2008 22:30:54 -0700 (PDT)
Message-Id: <20080429.223054.167583182.davem@davemloft.net>
To: bunk@kernel.org
Cc: linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
       linville@tuxdriver.com, torvalds@linux-foundation.org, yi.zhu@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: [2.6 patch] iwlwifi: move the selects to the tristate drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080428205849.GB2813@cs181133002.pp.htv.fi>
References: <20080428131552.GI16379@cs181133002.pp.htv.fi>
	<20080428142129.GA5679@beyonder.ift.unesp.br>
	<20080428205849.GB2813@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 28 Apr 2008 23:58:49 +0300

> This patch moves the following select's:
> - RFKILL        : IWLWIFI_RFKILL -> IWLCORE
> - RFKILL_INPUT  : IWLWIFI_RFKILL -> IWLCORE
> - MAC80211_LEDS : IWL4965_LEDS   -> IWLCORE
> - LEDS_CLASS    : IWL4965_LEDS   -> IWLCORE
> - MAC80211_LEDS : IWL3945_LEDS   -> IWL3945
> - LEDS_CLASS    : IWL3945_LEDS   -> IWL3945
> 
> The effects are:
> - with IWLCORE=m and/or IWL3945=m RFKILL/RFKILL_INPUT/MAC80211_LEDS/LEDS_CLASS
>   are no longer wrongly forced to y
> - fixes a build error with IWLCORE=y, IWL4965=m
>   might be a bug in kconfig causing it, but doing this change that is 
>   anyway the right thing fixes it
> 
> Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks a lot Adrian.
