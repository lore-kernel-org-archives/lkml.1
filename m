Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYJ1Bdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYJ1Bdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJ1Bdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:33:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:49530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbYJ1Bdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:33:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,495,1220252400"; 
   d="scan'208";a="396599764"
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
From: Zhu Yi <yi.zhu@intel.com>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20081028020212.0dfcb6c9@mtlp.12.dimension>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
Content-Type: text/plain
Organization: Intel Corp.
Date: Tue, 28 Oct 2008 09:33:37 +0800
Message-Id: <1225157618.2917.215.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 18:02 -0700, Mirco Tischler wrote:
> Hi
> 
> I have problems connecting to wlan with my iwl4965 chip and 2.6.28-rc2 (didn't
> test -rc1). Networkmanager just times out every time.
> Only after playing around with rmmod/modprobe and killswitch I am sometimes
> able to connect. But I cannot reproduce this reliably yet.
> 
> This is what I get in dmesg (from modprobe iwlagn to connection failure):
> 
> [ 1881.884690] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
> Linux,1.3.27kds
> [ 1881.884692] iwlagn: Copyright(c) 2003-2008 Intel Corporation
> [ 1881.884809] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [ 1881.884836] iwlagn 0000:06:00.0: setting latency timer to 64
> [ 1881.884952] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
> [ 1881.935149] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
> [ 1881.936327] phy4: Selected rate control algorithm 'iwl-agn-rs'
> [ 1885.965591] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [ 1885.965874] iwlagn 0000:06:00.0: irq 41 for MSI/MSI-X
> [ 1885.965974] iwlagn 0000:06:00.0: firmware: requesting iwlwifi-4965-2.ucode
> [ 1886.181600] Registered led device: iwl-phy4:radio
> [ 1886.181618] Registered led device: iwl-phy4:assoc
> [ 1886.181635] Registered led device: iwl-phy4:RX
> [ 1886.181654] Registered led device: iwl-phy4:TX
> [ 1886.213631] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 1887.572768] iwlagn: TX Power requested while scanning!

Looks good so far. But I failed to see what are you trying to connect?
Can you try "iwconfig wlan0 channnel <> essid <>"?

> What might be related is this early on boot:
> 
> [    0.163009] cfg80211: Calling CRDA to update world regulatory domain
> [    0.163012] cfg80211: Failed calling CRDA
> [    0.163024] cfg80211: calling CRDA failed - unable to update world
> regulatory domain, using static definition

Does your AP work on A band?

Thanks,
-yi

