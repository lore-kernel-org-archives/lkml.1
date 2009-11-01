Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbZKAIzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbZKAIzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 03:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZKAIzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 03:55:49 -0500
Received: from lucidpixels.com ([75.144.35.66]:55516 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZKAIzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 03:55:48 -0500
Date: Sun, 1 Nov 2009 03:55:53 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, nut-upsuser@lists.alioth.debian.org,
       bruce.w.allan@intel.com, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?]
 [tested 3 different UPS']
In-Reply-To: <20091031170749.4c2470ff@infradead.org>
Message-ID: <alpine.DEB.2.00.0911010339510.14999@p34.internal.lan>
References: <Pine.LNX.4.44L0.0910311115301.7118-100000@netrider.rowland.org> <alpine.DEB.2.00.0910311847530.5522@p34.internal.lan> <20091031170749.4c2470ff@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Oct 2009, Arjan van de Ven wrote:

> On Sat, 31 Oct 2009 19:43:38 -0400 (EDT)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>> Problem appears to be the Intel P55KG / USB Chipset in the way
>>>> that it handles usbhid-raw devices as CD/USB sticks/kbd/mouse/etc
>>>> do not appear to be affected.
>>>>
>>>> So far all other USB devices work fine, with the exception of
>>>> UPS', I have tested two APC 1500VA (one an RS the other an XS), in
>>>> addition I also have a 'BELKIN 1200VA UPS with AVR' from a long
>>>> time ago, the same problem occurs.
>>>
>>> ...
>>>
>>>> A bit frustrated, I popped in a PCI card with 4 external USBs, and
>>>> now no more errors:
>
>
> just as a wild guess;
> does it go away if you disable CONFIG_USB_SUSPEND ?
>
> also, google suggests that your bios may not have c-states enabled;
> if so, enabling those in the bios might also be a good idea

Hi Arjan,

Thanks for the reply,

http://home.comcast.net/~jpiszcz/20091101/config-2.6.31.4-7-PROD.txt
http://home.comcast.net/~jpiszcz/20091101/config-2.6.31.4-8-USB-DEBUG.txt

I do not use that option btw:

$ grep CONFIG_USB_SUSPEND .config
# CONFIG_USB_SUSPEND is not set

I rebooted to the BIOS and verified that the CPU C states are enabled.

Justin.

