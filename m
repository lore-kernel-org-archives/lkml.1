Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYJTMRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYJTMRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYJTMRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:17:14 -0400
Received: from isilmar.linta.de ([213.133.102.198]:39243 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986AbYJTMRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:17:13 -0400
Date: Mon, 20 Oct 2008 14:17:10 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Dieter Ries <clip2@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945 broken in current git
Message-ID: <20081020121710.GA3607@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Dieter Ries <clip2@gmx.de>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
References: <48FC6C05.6020901@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FC6C05.6020901@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 01:31:17PM +0200, Dieter Ries wrote:
> Hi,
> 
> with latest git I cannot use my intel 3945 wifi. It shows up in
> ifconfig, but it just does not work.
> 
> dmesg output is:
> 
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for
> Linux, 1.2.26ks
> iwl3945: Copyright(c) 2003-2008 Intel Corporation
> iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwl3945 0000:03:00.0: setting latency timer to 64
> iwl3945: Detected Intel Wireless WiFi Link 3945ABG
> iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> phy1: Selected rate control algorithm 'iwl-3945-rs'
> iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-1.ucode
> Registered led device: iwl-phy1:radio
> Registered led device: iwl-phy1:assoc
> Registered led device: iwl-phy1:RX
> Registered led device: iwl-phy1:TX
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
> 0x4416 ser 0x0000004B
> iwl3945: Can't stop Rx DMA.

It needs a more recent uCode -- the driver really should scream out loudly
that the old firmware no longer suffices.

Best,
	Dominik
