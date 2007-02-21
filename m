Return-Path: <linux-kernel-owner+w=401wt.eu-S1751237AbXBUMY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbXBUMY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932444AbXBUMY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:24:28 -0500
Received: from khc.piap.pl ([195.187.100.11]:42319 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbXBUMY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:24:28 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>
	<45DA7643.4020305@xs4all.nl>
	<200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl>
	<45DC0FCC.7010705@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 21 Feb 2007 13:24:24 +0100
In-Reply-To: <45DC0FCC.7010705@xs4all.nl> (Udo van den Heuvel's message of "Wed, 21 Feb 2007 10:24:28 +0100")
Message-ID: <m3wt2bem13.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> So if my non-VIA riser card can use DN 19 and also INT_A things should work?

That INT_A may be INT_A from their (motherboard) point of view, but
the riser card doesn't know about that, it only knows INTs as seen
at its PCI edge connector (so this INT_A here is meaningless).

Device numbers aren't rotated but rather derived from address lines
(address/data). AD0-31 lines are the same across the whole PCI bus.
That means device numbers are independent of POV.

> (assuming that VIA Epia EN BIOS 1.07 is enough to use this card)

My VIA EPIA-M 600 is probably older than your one, so I'd assume
it should work as well.
When you configure 0x13 and 0x14, both devices get IRQs - that means
the BIOS can see both of them.

> The DN is the only variable so INT lines are hardwired on the riser card?

Yep. You just need a bit of soldering.
-- 
Krzysztof Halasa
