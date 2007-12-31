Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbXLaA4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbXLaA4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 19:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbXLaA4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 19:56:30 -0500
Received: from slackadelic.com ([65.196.224.53]:53633 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbXLaA43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:56:29 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
Date: Mon, 31 Dec 2007 00:56:16 +0000
User-Agent: KMail/1.9.7
Cc: oakad@exemail.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, drzeus@drzeus.cx,
       Alex Dubov <oakad@yahoo.com>
References: <1198465597-14059-1-git-send-email-oakad@exemail.com.au> <200712310001.15395.carlos@strangeworlds.co.uk> <Pine.LNX.4.64.0712310123540.2093@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712310123540.2093@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712310056.17457.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 00:31:12 Jan Engelhardt wrote:
> On Dec 31 2007 00:01, Carlos Corbacho wrote:
> >On Monday 24 December 2007 03:06:37 oakad@exemail.com.au wrote:
> >> From: Alex Dubov <oakad@yahoo.com>
> >>
> >> Sony MemoryStick cards are used in many products manufactured by Sony.
> >> They are available both as storage and as IO expansion cards. Currently,
> >> only MemoryStick Pro storage cards are supported via TI FlashMedia
> >> MemoryStick interface.
>
> Actually... my MS slot on PCG-U3 is recognized through usb_storage.

Then consider yourself very lucky - some laptop manufacturers play nice and 
the card reader identifies itself, and works as, a USB mass storage device; 
so it works out of the box with no extra drivers needed for either the card 
reader, or the flash memory card.

The Texas Instruments chip/ card reader that Alex's work here is currently 
aimed at does not - it has a completely proprietary, so called "FlashMedia" 
chip/ interface that talks to MMC/ SD, MemoryStick (/ Pro), and SmartMedia/ 
xD cards, of which TI have refused to release any specs.

Yes, this chip doesn't even use sdhci for communicating with MMC/ SD cards - 
tifm_sd (Alex's previous work on the MMC/ SD front for this TI chip) handles 
that.

MemoryStick support is more complicated in this case than MMC/ SD, given that 
on top of TI refusing to release specs for their own FlashMedia chips, Sony 
will also not release any specs on MemoryStick cards; the same is also true 
of xD with Olympus and Fuji.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
