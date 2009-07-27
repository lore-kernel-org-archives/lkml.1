Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbZG0QDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbZG0QDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZG0QDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:03:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:26511 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZG0QDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:03:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,277,1246863600"; 
   d="scan'208";a="536302557"
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: reinette chatre <reinette.chatre@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       johannes@sipsolutions.net
In-Reply-To: <20090726075738.GA21333@ics.muni.cz>
References: <20090726075738.GA21333@ics.muni.cz>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 09:03:38 -0700
Message-Id: <1248710618.1216.452.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

On Sun, 2009-07-26 at 00:57 -0700, Lukas Hejtmanek wrote:
> Hello,
> 
> I noticed regression in 2.6.31-rc{3,4}. iwlagn driver does not work for me.
> I got:
> ifconfig wlan0 up
> SIOCSIFFLAGS: Unknown error 132

yes - this is a rfkill error

> 
> dmesg shows:
> [ 1812.806813] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
> 1.3.27kds
> [ 1812.806820] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> [ 1812.806996] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [ 1812.807024] iwlagn 0000:03:00.0: setting latency timer to 64
> [ 1812.807699] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 4965AGN
> REV=0x4
> [ 1812.860879] iwlagn 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a
> channels
> [ 1812.861012]   alloc irq_desc for 32 on node -1
> [ 1812.861017]   alloc kstat_irqs on node -1
> [ 1812.861069] iwlagn 0000:03:00.0: irq 32 for MSI/MSI-X
> [ 1812.882796] phy0: Selected rate control algorithm 'iwl-agn-rs'
> 
> I definitely have rfkill on. I tried to even toggle rfkill, no success. The HW
> is Lenovo T61 (thus acer/hp rfkill patches do not work for me).

Maybe Johannes knows if there is something that you need for thinkpad.

Reinette


