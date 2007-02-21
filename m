Return-Path: <linux-kernel-owner+w=401wt.eu-S1751307AbXBUPAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbXBUPAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXBUPAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:00:45 -0500
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2637 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXBUPAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:00:30 -0500
Message-ID: <45DC5E67.8060101@xs4all.nl>
Date: Wed, 21 Feb 2007 15:59:51 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Krzysztof Halasa <khc@pm.waw.pl>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>	<45DA7643.4020305@xs4all.nl>	<200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl>	<45DC0FCC.7010705@xs4all.nl> <m3wt2bem13.fsf@maximus.localdomain>
In-Reply-To: <m3wt2bem13.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> writes:
> 
>> So if my non-VIA riser card can use DN 19 and also INT_A things should work?
> 
> That INT_A may be INT_A from their (motherboard) point of view, but
> the riser card doesn't know about that, it only knows INTs as seen
> at its PCI edge connector (so this INT_A here is meaningless).
> 
> Device numbers aren't rotated but rather derived from address lines
> (address/data). AD0-31 lines are the same across the whole PCI bus.
> That means device numbers are independent of POV.
> 
>> (assuming that VIA Epia EN BIOS 1.07 is enough to use this card)
> 
> My VIA EPIA-M 600 is probably older than your one, so I'd assume
> it should work as well.
> When you configure 0x13 and 0x14, both devices get IRQs - that means
> the BIOS can see both of them.

But the IRQ for the DVB-T card doesn't work.
I would need to test the DVB-T card alone to be sure it has working IRQ.
If so, what would be the conclusion?

>> The DN is the only variable so INT lines are hardwired on the riser card?
> 
> Yep. You just need a bit of soldering.

What IRQ rerouting would I need to try? 1 of 3 choices?
Or one best bet?

Udo
