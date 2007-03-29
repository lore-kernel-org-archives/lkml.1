Return-Path: <linux-kernel-owner+w=401wt.eu-S934353AbXC2WJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbXC2WJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934358AbXC2WJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:09:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53914 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353AbXC2WJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:09:26 -0400
Date: Thu, 29 Mar 2007 15:06:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: David Brownell <david-b@pacbell.net>, Andrew Morton <akpm@osdl.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Olech <tony.olech@elandigitalsystems.com>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.20-rc4-mm1: different values for OHCI_QUIRK_ZFMICRO
Message-Id: <20070329150638.83dcf1fa.randy.dunlap@oracle.com>
In-Reply-To: <20070220000654.GK13958@stusta.de>
References: <20070111222627.66bb75ab.akpm@osdl.org>
	<20070114091016.GS7469@stusta.de>
	<200701140636.11657.david-b@pacbell.net>
	<20070220000654.GK13958@stusta.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 01:06:54 +0100 Adrian Bunk wrote:

> On Sun, Jan 14, 2007 at 06:36:10AM -0800, David Brownell wrote:
> > On Sunday 14 January 2007 1:10 am, Adrian Bunk wrote:
> > > <--  snip  -->
> > 
> > Waiting for Tony to submit bugfixes to his driver...
> 
> Still unfixed as of 2.6.20-mm1.
> 
> > > ...
> > >   CC      drivers/usb/misc/ftdi-elan.o
> > > /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/ftdi-elan.c:2307:1: warning: "OHCI_QUIRK_ZFMICRO" redefined
> > > In file included from /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/ftdi-elan.c:76:
> > > /home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/usb/misc/../host/ohci.h:399:1: warning: this is the location of the previous definition
> > > ...
> > > $ grep -r ^#define * | grep OHCI_QUIRK_ZFMICRO  
> > > drivers/usb/host/ohci.h:#define OHCI_QUIRK_ZFMICRO      0x20                   /* Compaq ZFMicro chipset*/
> > > drivers/usb/host/u132-hcd.c:#define OHCI_QUIRK_ZFMICRO 0x10
> > > drivers/usb/misc/ftdi-elan.c:#define OHCI_QUIRK_ZFMICRO 0x10
> > > $ 
> > > 
> > > <--  snip  -->

so is there a patch around for this yet?

or shall someone other than Tony (??) make one?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
