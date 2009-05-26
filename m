Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZEZQpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZEZQpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZEZQpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:45:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:62909 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZEZQpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:45:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,252,1241420400"; 
   d="scan'208";a="460519281"
Subject: Re: [ipw3945-devel] iwlagn (5300) broken: 2.6.30-rc7, linux-next
From: reinette chatre <reinette.chatre@intel.com>
To: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>
Cc: "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Linux Next Mailing List <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090525072138.GA5568@ikn.schottelius.org>
References: <20090525072138.GA5568@ikn.schottelius.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 09:51:50 -0700
Message-Id: <1243356710.7624.3001.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-05-25 at 00:21 -0700, Nico -telmich- Schottelius wrote:
> Hello!
> 
> I cannot authenticate agains any AP with
> 
>   - 2.6.30-rc5-next-20090514-05233,
>   - 2.6.30-rc5-next-20090515-05297-g9bbe396,
>   - 2.6.30-rc7
> 
> dmesg, .config for 2.6.30-rc6 are attached.
> 
> I'm using wpa_supplicant to try to establish the connection.
> Sorry for the late report, just switched back to wired lan
> the last weeks.
> 
> Sincerly,
> 
> Nico

[...]

> [   11.957125] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> [   11.957135] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> [   11.957312] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   11.957328] iwlagn 0000:03:00.0: setting latency timer to 64
> [   11.957674] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
> [   11.977183] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> [   11.977301] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X

[...]

> [  103.061679] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.ucode
> [  103.087303] ip_tables: (C) 2000-2006 Netfilter Core Team
> [  103.439449] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
> [  103.686328] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  106.716528] wlan0: authenticate with AP 00:03:52:1c:18:71
> [  106.718503] wlan0: authenticated
> [  106.718512] wlan0: associate with AP 00:03:52:1c:18:71
> [  106.916177] wlan0: associate with AP 00:03:52:1c:18:71
> [  106.918120] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=0x421 status=1 aid=0)
> [  106.918128] wlan0: AP denied association (code=1)

You need to find out why your AP denied the association request. Here it
may help to run wpa_supplicant in debug mode.

> [  107.116202] wlan0: associate with AP 00:03:52:1c:18:71
> [  107.118167] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=0x421 status=1 aid=0)
> [  107.118174] wlan0: AP denied association (code=1)
> [  107.316128] wlan0: association with AP 00:03:52:1c:18:71 timed out

[...]


> [  243.192345] iwlagn 0000:03:00.0: PCI INT A disabled
> [  243.304966] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> [  243.304971] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> [  243.305090] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [  243.305122] iwlagn 0000:03:00.0: setting latency timer to 64
> [  243.305210] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
> [  243.337281] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> [  243.337366] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
> [  243.338184] phy1: Selected rate control algorithm 'iwl-agn-rs'
> [  245.441513] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.ucode
> [  245.493091] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
> [  245.737314] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  249.867702] wlan0: authenticate with AP 00:03:52:1c:18:71
> [  249.875512] wlan0: authenticate with AP 00:03:52:4d:bd:c1
> [  249.878565] wlan0: authenticate with AP 00:03:52:4d:bd:c1
> [  249.905107] wlan0: authenticated
> [  249.905116] wlan0: associate with AP 00:03:52:4d:bd:c1
> [  249.907466] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=0x421 status=0 aid=2)
> [  249.907473] wlan0: associated
> [  249.914879] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  249.920414] wlan0: disassociating by local choice (reason=3)

This is wpa_supplicant disassociating.



> [  249.935823] wlan0: authenticate with AP 00:03:52:1c:18:71
> [  250.026193] wlan0: authenticate with AP 00:03:52:1c:18:71
> [  250.030259] wlan0: authenticate with AP 00:03:52:1c:18:71
> [  250.030313] wlan0: authenticated
> [  250.030319] wlan0: associate with AP 00:03:52:1c:18:71
> [  250.054947] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=0x421 status=0 aid=1)
> [  250.054955] wlan0: associated
> [  250.061078] wlan0: disassociating by local choice (reason=3)

again

> [  250.076398] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
> [  250.182475] wlan0: authenticate with AP 00:03:52:1b:f8:31
> [  250.183507] wlan0: authenticate with AP 00:03:52:1b:f8:31
> [  250.380163] wlan0: authenticate with AP 00:03:52:1b:f8:31
> [  250.580141] wlan0: authenticate with AP 00:03:52:1b:f8:31
> [  250.592714] wlan0: authenticated
> [  250.592723] wlan0: associate with AP 00:03:52:1b:f8:31
> [  250.594870] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=0x421 status=0 aid=2)
> [  250.594878] wlan0: associated
> [  250.601994] wlan0: disassociating by local choice (reason=3)

... and again

> [  250.707306] wlan0: authenticate with AP 00:03:52:4e:f3:d1
> [  250.709306] wlan0: authenticated
> [  250.709313] wlan0: associate with AP 00:03:52:4e:f3:d1
> [  250.711452] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=0x421 status=0 aid=3)
> [  250.711459] wlan0: associated
> [  250.718720] wlan0: disassociating by local choice (reason=3)

... and again.

[...]

It really seems that runnning wpa_supplicant with debugging will help in
understanding what is going on in your environment.

Reinette


