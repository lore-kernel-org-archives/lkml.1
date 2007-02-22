Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXBVQAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXBVQAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933110AbXBVQAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:00:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45712 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102AbXBVQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:00:24 -0500
Date: Thu, 22 Feb 2007 16:00:16 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
In-Reply-To: <1172157592.5837.89.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702221558550.29542@pentafluge.infradead.org>
References: <20070219044616.GC25659@washoe.onerussian.com> 
 <20070219000412.acad13de.akpm@linux-foundation.org> 
 <1171876788.6046.3.camel@localhost.localdomain>  <877iub9mu2.fsf@sycorax.lbl.gov>
  <1172097718.5790.29.camel@localhost.localdomain>  <20070221231706.GA3336@khazad-dum.debian.net>
  <1172103159.5790.45.camel@localhost.localdomain>  <20070222005122.GA7928@khazad-dum.debian.net>
  <20070222011017.GA8845@khazad-dum.debian.net>  <1172138450.5837.34.camel@localhost.localdomain>
  <20070222145613.GD25887@khazad-dum.debian.net> <1172157592.5837.89.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Howerver, I *do* strongly wish for a way to combine various drivers into a
> > single backlight device, where radeon/intelfb takes care of some stuff,
> > ibm-acpi/asus-laptop/sony-laptop takes care of other stuff, etc.  Also, a
> > standard naming for the builtin screen(s) would help, calling it "ibm",
> > "asus", "sony" is not good IMHO.
> 
> I wasn't aware of this problem. If some devices need bits from both
> raedon/whatever and acpi, the current implementations are just plain
> wrong. Its not really a backlight class problem and more of an
> implementation and interaction problem between acpi and the framebuffer
> drivers. They should be presenting and registering *one* backlight class
> device, not two. Without knowing more about the circumstances and
> how/when to combine which drivers its hard for me to help further...

This is always been a problem. For the fbdev layer you can run vesafb with 
a specific fbdev driver and they both access the same hardware. There is 
no really way around this. The user has to be smart enough to not enable 
bothe drivers.

