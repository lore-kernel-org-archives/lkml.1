Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbZKAAGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbZKAAGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 20:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933360AbZKAAGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 20:06:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:55682 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351AbZKAAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 20:06:34 -0400
Date: Sat, 31 Oct 2009 17:07:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, nut-upsuser@lists.alioth.debian.org,
       bruce.w.allan@intel.com, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?]
 [tested 3 different UPS']
Message-ID: <20091031170749.4c2470ff@infradead.org>
In-Reply-To: <alpine.DEB.2.00.0910311847530.5522@p34.internal.lan>
References: <Pine.LNX.4.44L0.0910311115301.7118-100000@netrider.rowland.org>
	<alpine.DEB.2.00.0910311847530.5522@p34.internal.lan>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009 19:43:38 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >> Problem appears to be the Intel P55KG / USB Chipset in the way
> >> that it handles usbhid-raw devices as CD/USB sticks/kbd/mouse/etc
> >> do not appear to be affected.
> >>
> >> So far all other USB devices work fine, with the exception of
> >> UPS', I have tested two APC 1500VA (one an RS the other an XS), in
> >> addition I also have a 'BELKIN 1200VA UPS with AVR' from a long
> >> time ago, the same problem occurs.
> >
> > ...
> >
> >> A bit frustrated, I popped in a PCI card with 4 external USBs, and
> >> now no more errors:


just as a wild guess;
does it go away if you disable CONFIG_USB_SUSPEND ?

also, google suggests that your bios may not have c-states enabled;
if so, enabling those in the bios might also be a good idea

-- 
Arjan van de Ven 	Intel Open Source Technology
CentreCONFIG_USB_SUSPEND For development, discussion and tips for power
savings,visit http://www.lesswatts.org
