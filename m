Return-Path: <linux-kernel-owner+w=401wt.eu-S934908AbYBGV0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908AbYBGV0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964916AbYBGVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:25:36 -0500
Received: from eazy.amigager.de ([213.239.192.238]:33135 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbYBGVZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:25:32 -0500
Date: Thu, 7 Feb 2008 22:25:29 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
Message-ID: <20080207212529.GA5975@dose.home.local>
Mail-Followup-To: Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
References: <20080206014131.9d489a34.akpm@linux-foundation.org> <1202294560-7313-1-git-send-email-jirislaby@gmail.com> <20080206150043.GA6921@nineveh.local> <b6c5339f0802060746m3a5f87edj4465797564430292@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c5339f0802060746m3a5f87edj4465797564430292@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 10:46:39 -0500, Bob Copeland wrote:
> > > We failed to resume after a hardware reset here for a whole second. Is there any
> > > version of ath5k which worked for you (is this a regression)?
> >
> > I cannot speak for Tino, but my ath5k never worked in MacBook -- it
> > failed the same way, and I believe the hardware was the same.  My
> > understanding was that it was a known bug with PCIE devices, but I got
> > that out of reading list archives.
> 
> Nick Kossifidis and I are in the process of debugging this -- we
> determined that AR5K_RESET_CTL_PCI hangs the card in hw_nic_wakeup.
> It doesn't look like there is any general support for 5424 cards yet.

I tried the patch, and the card was detected. I was able to associate
with an WPA2 AP and send/receive some traffic. But after a while the
interface broke:

ath0: No ProbeResp from current AP 00:14:bf:16:25:87 - assume out of
range
ath5k_hw_get_isr: 0x00000020
...
ath0: failed to set channel 165 (5825 MHz) for scan
ath0: failed to restore operational channel after scan
printk: 19 messages suppressed.
ath5k phy0: calibration timeout (2447MHz)
printk: 1 messages suppressed.
ath5k phy0: calibration timeout (2447MHz)
ath5k phy0: unable to reset hardware: -11

Regards,
Tino
