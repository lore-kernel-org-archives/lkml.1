Return-Path: <linux-kernel-owner+w=401wt.eu-S965338AbXBUJYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338AbXBUJYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 04:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXBUJYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 04:24:42 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4552 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338AbXBUJYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 04:24:41 -0500
Message-ID: <45DC0FCC.7010705@xs4all.nl>
Date: Wed, 21 Feb 2007 10:24:28 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl>
In-Reply-To: <45DB174F.30708@xs4all.nl>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> Any ideas about how to proceed?
> What to test?

I found some info on the VIA dual PCI extender card at
http://www.itx-warehouse.co.uk/Product.aspx?ProductID=410.
The text says:

The EXT-PCI is a PCI riser card which expands a PCI slot into two PCI slots.

EXT-PCI slot 1 (lower slot) uses the system resources (Device ID, INT)
of the PCI slot of the motherboard.

EXT-PCI slot 2 (Upper slot) uses device 19 and INT_A.



So if my non-VIA riser card can use DN 19 and also INT_A things should work?
(assuming that VIA Epia EN BIOS 1.07 is enough to use this card)

So, if not (as in my situation) how can I find out what is wrong?
Or find out if the BIOS works OK with the card?
How can I verify that the correct routing for the IRQ is in place?
The DN is the only variable so INT lines are hardwired on the riser card?
Then same for the motherboard.


I.o.w.: how can I find the root cause?

Kind regards,
Udo
