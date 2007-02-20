Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXBTAT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXBTAT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbXBTAHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:07:09 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36042 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750915AbXBTAGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:06:55 -0500
Date: Tue, 20 Feb 2007 01:06:54 +0100
From: Adrian Bunk <bunk@stusta.de>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@osdl.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Olech <tony.olech@elandigitalsystems.com>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.20-rc4-mm1: different values for OHCI_QUIRK_ZFMICRO
Message-ID: <20070220000654.GK13958@stusta.de>
References: <20070111222627.66bb75ab.akpm@osdl.org> <20070114091016.GS7469@stusta.de> <200701140636.11657.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701140636.11657.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 14, 2007 at 06:36:10AM -0800, David Brownell wrote:
> On Sunday 14 January 2007 1:10 am, Adrian Bunk wrote:
> > <--  snip  -->
> 
> Waiting for Tony to submit bugfixes to his driver...

Still unfixed as of 2.6.20-mm1.

> > ...
> >   CC      drivers/usb/misc/ftdi-elan.o
> > /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/ftdi-elan.c:2307:1: warning: "OHCI_QUIRK_ZFMICRO" redefined
> > In file included from /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/ftdi-elan.c:76:
> > /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/../host/ohci.h:399:1: warning: this is the location of the previous definition
> > ...
> > $ grep -r ^#define * | grep OHCI_QUIRK_ZFMICRO  
> > drivers/usb/host/ohci.h:#define OHCI_QUIRK_ZFMICRO      0x20                   /* Compaq ZFMicro chipset*/
> > drivers/usb/host/u132-hcd.c:#define OHCI_QUIRK_ZFMICRO 0x10
> > drivers/usb/misc/ftdi-elan.c:#define OHCI_QUIRK_ZFMICRO 0x10
> > $ 
> > 
> > <--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

