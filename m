Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbZBNUKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbZBNUKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZBNUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:10:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZBNUKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:10:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [Bug #12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
Date: Sat, 14 Feb 2009 21:10:03 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       reinette.chatre@intel.com
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <b6a2187b0902140341y2a1da743o7b012e6386583a62@mail.gmail.com> <b6a2187b0902141046r76f80b9ar6df6a0e2472ef61b@mail.gmail.com>
In-Reply-To: <b6a2187b0902141046r76f80b9ar6df6a0e2472ef61b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142110.03616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009, Jeff Chua wrote:
> On Sat, Feb 14, 2009 at 7:41 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > On Wed, Feb 4, 2009 at 6:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12414
> >> Subject         : iwl4965 cannot use "ap auto" on latest 2.6.28/29?
> >> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> >> Date            : 2009-01-05 4:13 (31 days old)
> >> References      : http://marc.info/?l=linux-kernel&m=123112882127823&w=4
> >
> > I applied the patch
> > http://marc.info/?l=linux-wireless&m=123320213115108&w=2 and it seems
> > better now. One instant of not association out of 20 tries, but
> > reloading the modules seems to make it work again. So, let's just
> > close the case?
> 
> I tested on another AP (WAG200G ), and this one, it's failing to
> associate more often. And I noticed that when it does associate, I
> don't get these two lines ...
> 
> iwlagn: TX Power requested while scanning!
> iwlagn: Error sending TX power (-11)
> 
> 
> 
> Here's a good run ...
> 
> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> iwlagn: Copyright(c) 2003-2008 Intel Corporation
> iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn 0000:03:00.0: setting latency timer to 64
> iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
> iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
> wmaster0 (iwlagn): not using net_device_ops yet
> phy0: Selected rate control algorithm 'iwl-agn-rs'
> wlan0 (iwlagn): not using net_device_ops yet
> iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn 0000:03:00.0: irq 28 for MSI/MSI-X
> iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
> iwlagn loaded firmware version 228.57.2.23
> Registered led device: iwl-phy0:radio
> Registered led device: iwl-phy0:assoc
> Registered led device: iwl-phy0:RX
> Registered led device: iwl-phy0:TX
> wlan0: authenticate with AP xxxxxxxxxxxxx
> wlan0: authenticate with AP xxxxxxxxxxxxx
> wlan0: authenticate with AP xxxxxxxxxxxxx
> wlan0: authenticated
> wlan0: associate with AP xxxxxxxxxxxx
> wlan0: RX AssocResp from xxxxxxxxxxxx (capab=0x471 status=0 aid=1)
> wlan0: associated

Thanks for the updates.

Rafael
