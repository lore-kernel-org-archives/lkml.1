Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbYBFJt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbYBFJt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 04:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbYBFJtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 04:49:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758211AbYBFJtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 04:49:46 -0500
Date: Wed, 6 Feb 2008 01:41:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: ath5k failure with 2.6.24-git14
Message-Id: <20080206014131.9d489a34.akpm@linux-foundation.org>
In-Reply-To: <20080205225746.GA4532@dose.home.local>
References: <20080205225746.GA4532@dose.home.local>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc linux-wireless)

On Tue, 5 Feb 2008 23:57:46 +0100 Tino Keitel <tino.keitel@gmx.de> wrote:

> Hi,
> 
> I tried the current git (9ef9dc69d4167276c04590d67ee55de8380bc1ad) and
> got the following error message from ath5k:
> 
> ath5k_pci 0000:02:00.0: registered as 'phy0'
> ath5k phy0: failed to resume the MAC Chip
> ath5k_pci: probe of 0000:02:00.0 failed with error -5
> 
> Here is the lspci -vnn output:
> 
> 02:00.0 Ethernet controller [0200]: Atheros Communications, Inc.
> AR5006EG 802.11 b/g Wireless PCI Express Adapter [168c:001c] (rev 01)
> 	Subsystem: Apple Computer Inc. Unknown device [106b:0086]
> 	Flags: fast devsel, IRQ 17
> 	Memory at 90100000 (64-bit, non-prefetchable) [disabled]
> 	[size=64K]
> 	Capabilities: [40] Power Management version 2
> 	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
> 	Queue=0/0 Enable-
> 	Capabilities: [60] Express Legacy Endpoint, MSI 00
> 	Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
> 	Capabilities: [100] Advanced Error Reporting <?>
> 	Capabilities: [140] Virtual Channel <?>
> 	Kernel modules: ath5k
> 
> The same device works with madwifi:
> 
> ath_rate_sample: 1.2 (svn r3339)
> MadWifi: ath_attach: Switching per-packet transmit power control off
> wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
> wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps
> 24Mbps 36Mbps 48Mbps 54Mbps
> wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> wifi0: H/W encryption support: WEP AES AES_CCM TKIP
> wifi0: ath_announce: Use hw queue 1 for WME_AC_BE traffic
> wifi0: ath_announce: Use hw queue 0 for WME_AC_BK traffic
> wifi0: ath_announce: Use hw queue 2 for WME_AC_VI traffic
> wifi0: ath_announce: Use hw queue 3 for WME_AC_VO traffic
> wifi0: ath_announce: Use hw queue 8 for CAB traffic
> wifi0: ath_announce: Use hw queue 9 for beacons
> ath_pci: wifi0: Atheros 5424/2424: mem=0x90100000, irq=17
> 
> I can also set the interface up and use iwlist ath0 scan.
> 

