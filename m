Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbXHAQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbXHAQIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXHAQIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:08:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:56628 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbXHAQIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:08:06 -0400
Date: Wed, 1 Aug 2007 19:08:05 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Hugh Dickins <hugh@veritas.com>, Len Brown <len.brown@intel.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       Richard Hughes <hughsient@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: THINKPAD_ACPI_INPUT_ENABLED seems regressive
Message-ID: <20070801160805.GB11758@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <Pine.LNX.4.64.0708011327200.4615@blonde.wat.veritas.com>
	<20070801153602.GJ23111@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801153602.GJ23111@khazad-dum.debian.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> Subject: Re: THINKPAD_ACPI_INPUT_ENABLED seems regressive
> 
> Cc's added.
> 
> On Wed, 01 Aug 2007, Hugh Dickins wrote:
> > When updating this IBM ThinkPad T43p from 2.6.22 to 2.6.23-rc1
> > using make oldconfig, the text and default Y of
> > 
> > config THINKPAD_ACPI_INPUT_ENABLED
> > 	bool "Enable input layer support by default"
> > 	depends on THINKPAD_ACPI
> > 	default y
> > 	---help---
> > 	  Enables hot key handling over the input layer by default.  If unset,
> > 	  the driver does not enable any hot key handling by default, and also
> > 	  starts up with a mostly empty keymap.
> > 
> > 	  If you are not sure, say Y here.  Say N to retain the deprecated
> > 	  behavior of ibm-acpi, and thinkpad-acpi for kernels up to 2.6.21.
> > 
> > made it sound like a good thing, so I configured it Y.  But its only
> > effect seems to be to disable the key I use most, Fn+F4 to suspend to
> > RAM.  It also disables Fn+F3 to blank the screen, though I don't use
> > that one; but does not disable the brightness and ThinkLight keys,
> > presumably because they just get mapped to KEY_RESERVED.
> 
> Actually, it doesn't disable the keys, but it routes them differently, so it
> will work well only if you have very up-to-date HAL, etc.
> 
> Richard, Matthew, would the HAL crowd be unhappy if I switch that default?
> 
> Distros with new enough userland would be expected to compile the kernel
> with THINKPAD_ACPI_INPUT_ENABLED, though.
> 
> > I get along fine now with THINKPAD_ACPI_INPUT_ENABLED disabled; but
> > suggest that its text is misleading, and default Y questionable.
> > Or perhaps there's a bug, and I can help try patches.
> 
> No bug in he code.  The help text should clearly be improved, and the
> default could be switched to N.  I will send in a patch, after I get a few
> comments.

Forcing the selection at compile-time isn't such a great idea IMHO.
Isn't there a way to support both old and new userspace?

-- 
MST
