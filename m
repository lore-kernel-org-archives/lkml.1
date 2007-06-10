Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbXFJTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbXFJTC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 15:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbXFJTCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 15:02:03 -0400
Received: from aun.it.uu.se ([130.238.12.36]:64612 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480AbXFJTCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 15:02:01 -0400
Date: Sun, 10 Jun 2007 21:01:49 +0200 (MEST)
Message-Id: <200706101901.l5AJ1nF6002970@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hancockr@shaw.ca, mikpe@it.uu.se
Subject: Re: PROBLEM: system clock slow on Athlon AMD64 since 2.6.21
Cc: ghpille@hotmail.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007 12:02:00 -0600, Robert Hancock wrote:
> Mikael Pettersson wrote:
> > On Fri, 08 Jun 2007 10:14:03 +0200, Gerard H. Pille wrote:
> >> [1.] One line summary of the problem:
> >> Since I switched from 2.6.20 to 2.6.21 on my Athlon AMD64 laptop, the system 
> >> time is slow - about 1' on 15'.
> > 
> > According to your system description it seems that you have a
> > Targa Visionary laptop with a VIA chipset and a Mobile Athlon64.
> > If so, then you probably have the same problem I reported some time
> > ago: see <http://marc.info/?l=linux-kernel&m=117681226421346&w=2>
> > and the followup messages. The conclusion was that the chipset's
> > ACPI PM timer slows down when the CPU is in C2.
> > 
> > The workaround is to boot with processor.max_cstate=1.
> 
> Which, if true, is extremely bizarre, as the whole point and reason for 
> existence of the ACPI PM timer is that it NOT do this, and remain at the 
> same rate regardless of CPU power management changes..

If you read the thread you'll find another bizarre fact: my laptop
only saw acpi_pm lose time when running a 64-bit kernel. With the
32-bit kernel acpi_pm worked fine in C2.

The C1 workaround is what the ACPI folks came up with. I was reluctant
to use it at first, but haven't really noticed any negative effects.

/Mikael
