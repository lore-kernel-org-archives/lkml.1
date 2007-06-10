Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbXFJUFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbXFJUFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbXFJUFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:05:07 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:54207 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758785AbXFJUFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:05:05 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sun, 10 Jun 2007 14:04:52 -0600
User-Agent: KMail/1.9.6
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706071234.47517.bjorn.helgaas@hp.com> <200706101203.04649.arvidjaar@mail.ru>
In-Reply-To: <200706101203.04649.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706101404.53083.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2007 02:03:03 am Andrey Borzenkov wrote:
> > Can you set CONFIG_ACPI_DEBUG=y, make it so smsc-ircc2 isn't loaded
> > automatically, and try this (along with my previous patch to swap
> > FIR and SIR):
> >
> >   # dmesg -n 8
> >   # echo 0x200 > /sys/module/acpi/parameters/debug_level
> >   # echo disable > /sys/bus/pnp/devices/00:0a/resources
> >   # echo activate > /sys/bus/pnp/devices/00:0a/resources
> >   # modprobe smsc-ircc2
> >
> > If you try this, can you collect the whole dmesg log?
> 
> well, dmesg (/var/log/messages) is around 35MB :) Even bz2 compressed it is 
> over 700KB. I put it here: 
> http://dump.ru:80/loadfile.php?filename=fir_acpi_debug.bz2&id=379192 
> 
> This is from /var/log/messages. I do not have serial console and cannot 
> capture output directly; I can only hope nothing is lost at this rate.

Wow, that is big :-)

I guess smsc-ircc2 still didn't find the device, so you got
something like this:

  smsc_ircc_present(), addr 0x02e8 - no device found!

Right?

I'm out of ideas, and I don't want to waste more of your time on
this.  I'm going to try to find a Portege 4000 to play with myself.
That might take a few days, and I'm going to be out of the office
from June 20-July 9, so I'm afraid it will be slow.  But I *will*
fix it!

Bjorn

