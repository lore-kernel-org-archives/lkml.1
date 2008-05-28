Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbYE1RKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbYE1RKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYE1RJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:09:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39528 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYE1RJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:09:55 -0400
Date: Wed, 28 May 2008 19:09:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Takashi Iwai <tiwai@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sound: azx_get_response timeout
In-Reply-To: <s5h1w4ox2d8.wl%tiwai@suse.de>
Message-ID: <alpine.LNX.1.10.0804291439100.21466@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804291225350.21466@fbirervta.pbzchgretzou.qr> <s5h63u0x6i4.wl%tiwai@suse.de> <alpine.LNX.1.10.0804291326160.21466@fbirervta.pbzchgretzou.qr> <s5h1w4ox2d8.wl%tiwai@suse.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-04-29 14:38, Takashi Iwai wrote:
>> >> Out of the blue, sound stops and dmesg throws:
>> >> 
>> >> ALSA sound/pci/hda/hda_intel.c:596: hda_intel: azx_get_response timeout, 
>> >> switching to polling mode: last cmd=0x000f0000
>> >
>> >It's a warining and usually OK as long as you don't get errors with
>> >single_cmd mode after this message.
>> 
>> Well I do ..
>
>Then the message is a red herring.

Ah nah.. for some reason I forgot to delete that line from the mail.

But then it seems to be running for half an hour with 2.6.23.17 so far, 
so that may be a bisection helping point. Will report bisect findings as 
comes available.

>> >What show /proc/asound/card0/codec#* files?
>>[..]
>
>This proc file looks fine.  You don't hear from the headphone but from
>the line-out jack, right?

The voulme control for 'Headphones' is 0, but I do hear things,
so I do use the "Master Front" mixer. (There is just one green
jack on the mainboard anyway.)

>To be sure, get the codec proc files before and after the problem to
>compare.  (lspci register dump might be worth to check, too.)

(have not booted into 2.6.25 again yet, but will do)
