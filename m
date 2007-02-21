Return-Path: <linux-kernel-owner+w=401wt.eu-S1751337AbXBUTyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbXBUTyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXBUTyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:54:53 -0500
Received: from khc.piap.pl ([195.187.100.11]:44465 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbXBUTyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:54:52 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>
	<45DA7643.4020305@xs4all.nl>
	<200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl>
	<45DC0FCC.7010705@xs4all.nl> <m3wt2bem13.fsf@maximus.localdomain>
	<45DC5E67.8060101@xs4all.nl> <45DC8B3A.2080301@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 21 Feb 2007 20:54:50 +0100
In-Reply-To: <45DC8B3A.2080301@xs4all.nl> (Udo van den Heuvel's message of "Wed, 21 Feb 2007 19:11:06 +0100")
Message-ID: <m3tzxfqoad.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> Is the situation, with default DN setting of 19 as displayed below,
> `normal` w.r.t. interrupts?
> I mean: Both the DVB card with DN19 and the Unichrome Pro video adapter
> have the same irq although they are on different busses.

It's normal (and consistent with EPIA-M). The first UHCI USB (#0)
could get it, too (but it may be connected differently with IO-APIC,
I haven't checked).

> How can I find out what INT_A/B/C/D line is mapped to what irq?

That "INT_A/B/C/D" stuff depends on the point of view. In the BIOS
setup you can select some IRQs (which Linux could change anyway)
but it's a chipset-centric view (not very useful here).

Every PCI card have INT_A/B/C/D signals and they are (may be) remapped
on the riser card and on the motherboard.
-- 
Krzysztof Halasa
