Return-Path: <linux-kernel-owner+w=401wt.eu-S1765311AbXFSCEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765311AbXFSCEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759526AbXFSCEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:04:15 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3941 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbXFSCEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:04:15 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Mon, 18 Jun 2007 19:03:09 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEFCELAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070619012517.GL14788@delft.aura.cs.cmu.edu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 19:03:44 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 18 Jun 2007 19:03:46 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The box could even be sold by third party vendors, I think they may even
> have started off that way, my old Series 1 had a big Philips logo on it.
> So now we make sure that this hardware refuses to boot any unsigned
> code, but it wasn't shipped containing GPLv3 software, so it's license
> terms simply does not apply.
>
> The software is shipped on a ROM card which can no longer be modified by
> the manufacturer or any third party, so it would seem to comply with the
> GPLv3. I can even imagine that the hardware is really general purpose
> but the ROM is encrypted so that only the BIOS/bootloader can unlock it.
>
> So the GPLv3 seems to fall short on actually preventing tivoization. It
> just requires an extra layer of indirection, ship hardware seperately
> from software.
>
> Jan

If this flaw is still the latest GPLv3 drafts, it should be fixed. It's a
simple, technical error that can easily be rectified.

I don't have the latest draft handy, but my recollection is that it talks
about software that is "transferred along with" hardware. What it should say
is object code that contains activation logic for hardware.

That is, if I ship the Linux kernel (assuming for the moment the Linux
kernel was under GPLv3) with special activation logic to run on platforms X,
Y, and Z, then the source code should have to include how to make my changes
have that same special activation logic for those same platforms.

If the GPLv3 doesn't do that, it's broken.

Note that I'm not opining on whether this is a good thing or a bad thing.
But people who choose the GPLv3 because they want to prohibit tivoization of
their software should in fact get that prohibition.

DS


