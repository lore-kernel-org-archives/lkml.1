Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZG0QIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZG0QIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZG0QIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:08:38 -0400
Received: from senator.holtmann.net ([87.106.208.187]:39773 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZG0QIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:08:37 -0400
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: Marcel Holtmann <marcel@holtmann.org>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       johannes@sipsolutions.net
In-Reply-To: <1248710618.1216.452.camel@rc-desk>
References: <20090726075738.GA21333@ics.muni.cz>
	 <1248710618.1216.452.camel@rc-desk>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 18:07:34 +0200
Message-Id: <1248710854.28545.202.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Reinette,

> > I noticed regression in 2.6.31-rc{3,4}. iwlagn driver does not work for me.
> > I got:
> > ifconfig wlan0 up
> > SIOCSIFFLAGS: Unknown error 132
> 
> yes - this is a rfkill error
> 
> > 
> > dmesg shows:
> > [ 1812.806813] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
> > 1.3.27kds
> > [ 1812.806820] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> > [ 1812.806996] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > [ 1812.807024] iwlagn 0000:03:00.0: setting latency timer to 64
> > [ 1812.807699] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 4965AGN
> > REV=0x4
> > [ 1812.860879] iwlagn 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a
> > channels
> > [ 1812.861012]   alloc irq_desc for 32 on node -1
> > [ 1812.861017]   alloc kstat_irqs on node -1
> > [ 1812.861069] iwlagn 0000:03:00.0: irq 32 for MSI/MSI-X
> > [ 1812.882796] phy0: Selected rate control algorithm 'iwl-agn-rs'
> > 
> > I definitely have rfkill on. I tried to even toggle rfkill, no success. The HW
> > is Lenovo T61 (thus acer/hp rfkill patches do not work for me).
> 
> Maybe Johannes knows if there is something that you need for thinkpad.

it works fine with my X200 and a 5350 card, but it could be that the
code inside the thinkpad driver is different for a T61.

Regards

Marcel


