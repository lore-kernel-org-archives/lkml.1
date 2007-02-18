Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXBRUuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXBRUuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXBRUuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:50:20 -0500
Received: from khc.piap.pl ([195.187.100.11]:47214 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbXBRUuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:50:19 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl>
	<20070218155445.GV7584@csclub.uwaterloo.ca>
	<45D87BA2.9020001@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 18 Feb 2007 21:50:16 +0100
In-Reply-To: <45D87BA2.9020001@xs4all.nl> (Udo van den Heuvel's message of "Sun, 18 Feb 2007 17:15:30 +0100")
Message-ID: <m3abzb8a2f.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> FYI: My situation is a VIA Epia EN12000 with a TranquilPC dual PCI riser
> where only the Device Number can be changed.

With jumpers?

> So IRQ 16 and 20. But when using the stock 2.6.20 kernel there is no
> communication with the DVB-T card (the frontend), so there is no
> /dev/dvb/* entry. This points to an IRQ problem.
>
> How can I find out the actual IRQ that the card is using?

I would remove the PCI cards and then the riser card and check INT
routing with a multimeter.
Perhaps a task for someone used to stuff like that.

> I set the BIOS for 'PnP OS installed'. Should I change that?

Most drivers already enable devices so it probably doesn't matter.
I would check it, though.
-- 
Krzysztof Halasa
