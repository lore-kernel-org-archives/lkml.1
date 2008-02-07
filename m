Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbYBGVvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbYBGVvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbYBGVvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:51:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:11236 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbYBGVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GaLUnHZ4Uf7BIR0KBPbJQ/S1Ab/7x/L4gCNWwF02xXYaEVqUEE4bk5EC5Atd1JGAgXYr7Lrvj3jk8/3X7gt6GbUGJ0nK2RvxwJH5d2ob0b5LIg18vIqjZfFwWJAH2E+OS4tE7Hoy3JYoB+Y4p9+8uVcvHMdJ+zd/1vOlJfnSE5Q=
Message-ID: <47AB7D48.2020805@gmail.com>
Date: Thu, 07 Feb 2008 22:51:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       linux-wireless@vger.kernel.org, Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [RFT 1/1] single_chip test
References: <20080206014131.9d489a34.akpm@linux-foundation.org> <1202294560-7313-1-git-send-email-jirislaby@gmail.com> <20080206150043.GA6921@nineveh.local> <b6c5339f0802060746m3a5f87edj4465797564430292@mail.gmail.com> <20080207212529.GA5975@dose.home.local>
In-Reply-To: <20080207212529.GA5975@dose.home.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2008 10:25 PM, Tino Keitel wrote:
> On Wed, Feb 06, 2008 at 10:46:39 -0500, Bob Copeland wrote:
>>>> We failed to resume after a hardware reset here for a whole second. Is there any
>>>> version of ath5k which worked for you (is this a regression)?
>>> I cannot speak for Tino, but my ath5k never worked in MacBook -- it
>>> failed the same way, and I believe the hardware was the same.  My
>>> understanding was that it was a known bug with PCIE devices, but I got
>>> that out of reading list archives.
>> Nick Kossifidis and I are in the process of debugging this -- we
>> determined that AR5K_RESET_CTL_PCI hangs the card in hw_nic_wakeup.
>> It doesn't look like there is any general support for 5424 cards yet.

Seems hold for this case too, as Bob noted.

> I tried the patch, and the card was detected. I was able to associate
> with an WPA2 AP and send/receive some traffic. But after a while the
> interface broke:
> 
> ath0: No ProbeResp from current AP 00:14:bf:16:25:87 - assume out of
> range
> ath5k_hw_get_isr: 0x00000020
> ...
> ath0: failed to set channel 165 (5825 MHz) for scan
> ath0: failed to restore operational channel after scan
> printk: 19 messages suppressed.
> ath5k phy0: calibration timeout (2447MHz)
> printk: 1 messages suppressed.
> ath5k phy0: calibration timeout (2447MHz)
> ath5k phy0: unable to reset hardware: -11

What's the srev a phy ver printed few lines above this, please?
