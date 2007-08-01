Return-Path: <linux-kernel-owner+w=401wt.eu-S1765610AbXHASvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765610AbXHASvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbXHASv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:51:27 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:45089 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753807AbXHASv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:51:26 -0400
Message-ID: <46B0D628.3050409@interia.pl>
Date: Wed, 01 Aug 2007 20:51:20 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Ash Willis <ashwillis@programmer.net>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, tiwai@suse.de
Subject: Re: CS5530 Alsa driver fails
References: <20070801174103.D03341F50B1@ws1-2.us4.outblaze.com>
In-Reply-To: <20070801174103.D03341F50B1@ws1-2.us4.outblaze.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: dc28eacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Rafał,
> It seems that you're already using irq 9 for another device, and as Alan says
> the cs5530 audio device doesn't seem to do irq sharing. It seems to me that you
> need to go into your BIOS settings at startup and tell the device to use an irq
> line that's not already in use by some other device. Can you please let me know
> if this works?
Sorry, I should mention earlier that this is Wyse 3360SE. I don't know how to 
enter BIOS (if there is any).
> The ALSA CS5530 driver is one that I ported from Alan's OSS Kahlua driver, so
> there may be some things that I've missed. If the above advice doesn't work,
> please confirm whether or not the device is functioning correctly in your
> current set up with Alan's original OSS driver.
I will give up. I didn't checked code earlier. This driver is using SMM. Probably  
firmware isn't what it should be, or I have overwritten it when I was flashing 
Linux. I see in datasheet that it isn't possible to write driver in other way. 
Sadly sound card is generating SMI only.

> Thanks,
> 
> Ash

Thank You
Rafał


----------------------------------------------------------------------
Dowiedz sie, co naprawde podnieca kobiety. Wiecej wiesz, latwiej je
oczarujesz 

>>>http://link.interia.pl/f1b17

