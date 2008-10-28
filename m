Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbYJ1EcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbYJ1EcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYJ1Eb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:31:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:60606 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYJ1Eb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:31:56 -0400
Date: Mon, 27 Oct 2008 21:32:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Mirco Tischler <mt-ml@gmx.de>, lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081027213217.53558319@infradead.org>
In-Reply-To: <1225157618.2917.215.camel@debian.sh.intel.com>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	<1225157618.2917.215.camel@debian.sh.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 09:33:37 +0800
Zhu Yi <yi.zhu@intel.com> wrote:

> On Mon, 2008-10-27 at 18:02 -0700, Mirco Tischler wrote:
> > Hi
> > 
> > I have problems connecting to wlan with my iwl4965 chip and
> > 2.6.28-rc2 (didn't test -rc1). Networkmanager just times out every
> > time. Only after playing around with rmmod/modprobe and killswitch
> > I am sometimes able to connect. But I cannot reproduce this
> > reliably yet.
> > 
> > This is what I get in dmesg (from modprobe iwlagn to connection
> > failure):
> > 
> > [ 1881.884690] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
> > Linux,1.3.27kds
> > [ 1881.884692] iwlagn: Copyright(c) 2003-2008 Intel Corporation
> > [ 1881.884809] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level,
> > low) -> IRQ 18 [ 1881.884836] iwlagn 0000:06:00.0: setting latency
> > timer to 64 [ 1881.884952] iwlagn: Detected Intel Wireless WiFi
> > Link 4965AGN REV=0x4 [ 1881.935149] iwlagn: Tunable channels: 13
> > 802.11bg, 19 802.11a channels [ 1881.936327] phy4: Selected rate
> > control algorithm 'iwl-agn-rs' [ 1885.965591] iwlagn 0000:06:00.0:
> > PCI INT A -> GSI 18 (level, low) -> IRQ 18 [ 1885.965874] iwlagn
> > 0000:06:00.0: irq 41 for MSI/MSI-X [ 1885.965974] iwlagn
> > 0000:06:00.0: firmware: requesting iwlwifi-4965-2.ucode
> > [ 1886.181600] Registered led device: iwl-phy4:radio [ 1886.181618]
> > Registered led device: iwl-phy4:assoc [ 1886.181635] Registered led
> > device: iwl-phy4:RX [ 1886.181654] Registered led device:
> > iwl-phy4:TX [ 1886.213631] ADDRCONF(NETDEV_UP): wlan0: link is not
> > ready [ 1887.572768] iwlagn: TX Power requested while scanning!
> 
> Looks good so far. But I failed to see what are you trying to connect?
> Can you try "iwconfig wlan0 channnel <> essid <>"?
> 

I had this same issue

turning on CONFIG_WIRELESS_OLD_REGULATORY fixed it for me....

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
