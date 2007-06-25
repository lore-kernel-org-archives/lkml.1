Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbXFYXRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbXFYXRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 19:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXFYXRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 19:17:30 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40196 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939AbXFYXR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 19:17:28 -0400
Date: Tue, 26 Jun 2007 01:17:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Hannu Savolainen <hannu@opensound.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070625231750.GF1094@stusta.de>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <s5h4pkwi9u0.wl%tiwai@suse.de> <4680310D.6060206@opensound.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4680310D.6060206@opensound.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 12:18:05AM +0300, Hannu Savolainen wrote:
>...
> What we would like to push is that the old "deprecated" OSS/Free are 
> removed from the kernel. OSS/Free is based on about years old OSS API 
> version which was too limited for many applications. Having OSS/Free in the 
> kernel doesn't serve any purpose.

I am slowly removing all parts of the in-kernel OSS with ALSA drivers 
for the same hardware.

The remaining drivers can roughly be divided into two categories:
- some ISA cards not supported by ALSA
- some drivers for unusual hardware (read: not a PC) not supported by ALSA

As long as we don't have ALSA drivers for them (which might in some 
cases never happen) I'd prefer to keep them for now.

> Also we would like to stop the silly OSS vs ALSA war. OSS and ALSA are 
> rather different. Both of them have some good points and bad points. For 
> ordinary users it doesn't matter which API is used by the applications as 
> long as they work. Just the application developers can see the real 
> difference. Some of them prefer OSS while some other prefer ALSA and this 
> should be their "freedom of choice".
>...

I'm glad to hear this.  :-)

> Best regards,
>
> Hannu

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

