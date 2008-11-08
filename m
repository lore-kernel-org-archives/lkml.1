Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYKHTP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYKHTP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKHTPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:15:48 -0500
Received: from colo.lackof.org ([198.49.126.79]:42686 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYKHTPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:15:47 -0500
Date: Sat, 8 Nov 2008 12:15:36 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Nobin Mathew <nobin.mathew@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sharing interrupt between PCI device
Message-ID: <20081108191536.GC28039@colo.lackof.org>
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no> <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com> <20081108172716.GA28039@colo.lackof.org> <4915E43E.4010206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4915E43E.4010206@gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 08:10:54PM +0100, Jiri Slaby wrote:
> Grant Grundler napsal(a):
> > So I see how the IRQ is enabled and disabled. I still don't see where
> > an interrupt handler is bound to IRQ 225 (output you posted today in
> > another email).
> 
> This irq setup is done during pci_enable_device.

Sorry, I wasn't quite correct: pci_enable_device() should only assign IRQs,
not enable them. request_irq() would enable them.

> > Nobin, can you dump /proc/interrupts when both drivers
> > are loaded and also send the dmesg output after both are loaded?
> 
> This won't show the hp driver as it doesn't request_irq.

Yup - that's what I expect too. But I was afraid something else might
be calling request_irq() and I'm just not seeing it. :)

grant
