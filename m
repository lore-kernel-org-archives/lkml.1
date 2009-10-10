Return-Path: <linux-kernel-owner+w=401wt.eu-S934639AbZJJAnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639AbZJJAnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbZJJAnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:43:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:21877 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757338AbZJJAnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:43:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,535,1249282800"; 
   d="scan'208";a="734920040"
Subject: Re: mmotm 2009-10-09-01-07 - iwl3945 fails to do firmware load
 request
From: Zhu Yi <yi.zhu@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <16108.1255133561@turing-police.cc.vt.edu>
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
	 <16108.1255133561@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 08:42:35 +0800
Message-Id: <1255135355.3719.22.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 08:12 +0800, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 09 Oct 2009 01:07:49 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-10-09-01-07 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Broke my iwl3945 wireless card:
> 
> Good (2.6.31-mmotm0917)
> Oct  8 09:55:33 turing-police kernel: [    0.809101] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
> Oct  8 09:55:33 turing-police kernel: [    0.809106] iwl3945: Copyright(c) 2003-2009 Intel Corporation
> Oct  8 09:55:33 turing-police kernel: [    0.809201] iwl3945 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> Oct  8 09:55:33 turing-police kernel: [    0.879463] iwl3945 0000:0c:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
> Oct  8 09:55:33 turing-police kernel: [    0.879466] iwl3945 0000:0c:00.0: Detected Intel Wireless WiFi Link 3945ABG
> ...
> Oct  8 09:55:35 turing-police kernel: [   31.599751] iwl3945 0000:0c:00.0: firmware: requesting iwlwifi-3945-2.ucode
> Oct  8 09:55:35 turing-police kernel: [   31.697046] iwl3945 0000:0c:00.0: loaded firmware version 15.28.2.8
> Oct  8 09:55:35 turing-police kernel: [   31.777214] Registered led device: iwl-phy0::radio
> Oct  8 09:55:35 turing-police kernel: [   31.777430] Registered led device: iwl-phy0::assoc
> Oct  8 09:55:35 turing-police kernel: [   31.777545] Registered led device: iwl-phy0::RX
> Oct  8 09:55:35 turing-police kernel: [   31.777676] Registered led device: iwl-phy0::TX
> Oct  8 09:55:35 turing-police kernel: [   31.789446] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> (and then wpa-supplicant is able to bring the card up when it finally gets launched by initscripts)
> 
> Bad 2.6.32-rc3-mmotm1009:
> 
> Oct  9 13:50:19 turing-police kernel: [    0.931788] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
> Oct  9 13:50:19 turing-police kernel: [    0.944678] iwl3945: Copyright(c) 2003-2009 Intel Corporation
> Oct  9 13:50:19 turing-police kernel: [    0.957831] iwl3945 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> Oct  9 13:50:19 turing-police kernel: [    1.038946] iwl3945 0000:0c:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
> Oct  9 13:50:19 turing-police kernel: [    1.038950] iwl3945 0000:0c:00.0: Detected Intel Wireless WiFi Link 3945ABG
> 
> We never see the firmware load request, and of course everything goes
> pear-shaped after that doesn't happen....

The firmware loading happens when the user space brings the interface
up. Can you check NM is running for the bad case?

Thanks,
-yi

