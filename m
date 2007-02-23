Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXBWSRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXBWSRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933162AbXBWSRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:17:07 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3686 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbXBWSRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:17:06 -0500
Message-ID: <45DF2F9E.20905@xs4all.nl>
Date: Fri, 23 Feb 2007 19:17:02 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>	<20070221224027.GK22464@csclub.uwaterloo.ca>	<200702212355.25601.s0348365@sms.ed.ac.uk>	<m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl> <m3wt2869nd.fsf@maximus.localdomain>
In-Reply-To: <m3wt2869nd.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> writes:
> 
>> I will try a different case with a different dual PCI riser card soon.
>> This Morex riser has DN20-31 or so, so more options.
>> Could this help solve my irq issue? (try 4 consecutive DNs until I have
>> the right mapping?)
> 
> I don't think so. Unless you can configure INT connections on the riser
> card, of course.
> 
> You need DN19 for the second slot (and perhaps 10 would work with
> double INTx rotation), that's fixed in the BIOS.

I have DN19 and DN20 now and it doesn't work.
Only because the INT mapping on the riser is not right?

http://www.morex.com.tw/drawing/MAR122-J%20Drawing.pdf shows some IDSEL
jumper with ADxx numbers. What could these be?
Photo at http://www.morex.com.tw/products/imgproduct/100-1.jpg.

Still DN's?

>> This Morex riser has DN20-31 or so, so more options.
>
> OTOH I wonder how do they use DN 21-31? The board uses lines AD11 to AD31
> (21 lines) for selecting devices #0 - #20. 32-bit PCI bus has only 32
> address/data lines :-)
>
> Perhaps they mean AD20-AD31 lines = device #9 - #0x14=20? If that is
> the case, you can try:
> - their "DN30" = device 0x13 = 19, which is apparently what the VIA riser
>   card does,
> - their "DN21" = device 0xA = 10, which could work as well.
>
> I'm afraid both would require (different) soldering.

So at least try the different jumper settings (without additional info,
I hope Morex responds to my emails).
Else do a little soldering.

> It's possible that the riser card includes a bridge, though. A bridge
> chip can select devices differently and thus it can handle 32 devices.

Looking at the photo I don't think I see a bridge...

