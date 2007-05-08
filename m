Return-Path: <linux-kernel-owner+w=401wt.eu-S934673AbXEHI3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673AbXEHI3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbXEHI3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:29:08 -0400
Received: from aun.it.uu.se ([130.238.12.36]:38034 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbXEHI3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:29:04 -0400
Date: Tue, 8 May 2007 10:26:49 +0200 (MEST)
Message-Id: <200705080826.l488Qnrb006666@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: khc@pm.waw.pl, mlj28@cam.ac.uk
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Cc: jeff@garzik.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       rmk@arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 08:22:17 +0100, Michael-Luke Jones wrote:
> On 8 May 2007, at 02:19, Krzysztof Halasa wrote:
> 
> > Adds a driver for built-in IXP4xx Ethernet MAC and HSS ports
...
> > +#ifndef __ARMEB__
> > +#warning Little endian mode not supported
> > +#endif
> 
> This has gone from error to warning - fair play but if are planning  
> to put this upstream this cycle (anything's possible :) ) you'll want  
> to declare this driver broken on ARMEB in Kconfig please.
> 
> Personally I'd like LE ethernet tested and working before we push.

AFAIK, it's a HW limitation of the IXP4xx NPEs, or
possibly Intel's microcode for them.

I run my IXP42x boxes big-endian and don't mind doing so.

/Mikael
