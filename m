Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYGPXX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYGPXX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759074AbYGPXXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:23:21 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:50775 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176AbYGPXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:23:20 -0400
Date: Wed, 16 Jul 2008 16:22:17 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Richard Purdie <rpurdie@rpsys.net>
cc: avorontsov@ru.mvista.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2] leds: implement OpenFirmare GPIO LED driver
In-Reply-To: <1216133032.5345.73.camel@dax.rpnet.com>
Message-ID: <Pine.LNX.4.64.0807161619050.12709@t2.domain.actdsltmp>
References: <20080715123822.GA10893@polina.dev.rtsoft.ru> 
 <20080715124013.GA13086@polina.dev.rtsoft.ru>  <1216126470.5345.55.camel@dax.rpnet.com>
  <20080715132438.GA26648@polina.dev.rtsoft.ru>  <1216128687.5345.61.camel@dax.rpnet.com>
  <20080715142354.GA3296@polina <1216133032.5345.73.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Richard Purdie wrote:
> On Tue, 2008-07-15 at 18:23 +0400, Anton Vorontsov wrote:
>>> Spell out openfirmware :). I initially had no idea "of == openfirmware"
>>> and I suspect others won't either...
>>
>> This would be unusually long name, that is
>>
>> $ find . -iname '*openfirmware*' | wc -l
>> 0
>>
>> And in contrast:
>>
>> drivers/video/offb.c
>> drivers/video/nvidia/nv_of.c
>> drivers/usb/host/ohci-ppc-of.c
>> drivers/usb/host/ehci-ppc-of.c
>> drivers/serial/of_serial.c
>> drivers/mtd/maps/physmap_of.c
>> ...
>>
>> So, I think we should stick with the "of" for consistency, while
>> confused users may consult with Kconfig for disambiguation.
>
> The other cases don't have a gpio driver to confuse this new driver
> with. Lets spell it out please, the filesystems can handle the extra
> letters :).

There's drivers/mtd/maps/physmap.c and drivers/mtd/maps/physmap_of.c,
drivers/serial/of_serial.c and drivers/serial/serial_core.c,
drivers/usb/host/ehci-ppc-soc.c and drivers/usb/host/ehci-ppc-of.c, etc.
