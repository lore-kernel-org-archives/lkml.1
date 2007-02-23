Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXBWSM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXBWSM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932523AbXBWSM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:12:28 -0500
Received: from khc.piap.pl ([195.187.100.11]:41948 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbXBWSM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:12:26 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>
	<20070221224027.GK22464@csclub.uwaterloo.ca>
	<200702212355.25601.s0348365@sms.ed.ac.uk>
	<m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 23 Feb 2007 19:12:24 +0100
In-Reply-To: <45DF0C29.2080201@xs4all.nl> (Udo van den Heuvel's message of "Fri, 23 Feb 2007 16:45:45 +0100")
Message-ID: <m3slcw68vr.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> I will try a different case with a different dual PCI riser card soon.
> This Morex riser has DN20-31 or so, so more options.

OTOH I wonder how do they use DN 21-31? The board uses lines AD11 to AD31
(21 lines) for selecting devices #0 - #20. 32-bit PCI bus has only 32
address/data lines :-)

Perhaps they mean AD20-AD31 lines = device #9 - #0x14=20? If that is
the case, you can try:
- their "DN30" = device 0x13 = 19, which is apparently what the VIA riser
  card does,
- their "DN21" = device 0xA = 10, which could work as well.

I'm afraid both would require (different) soldering.


It's possible that the riser card includes a bridge, though. A bridge
chip can select devices differently and thus it can handle 32 devices.
-- 
Krzysztof Halasa
