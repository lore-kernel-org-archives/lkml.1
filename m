Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbXKVCUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbXKVCUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 21:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXKVCUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 21:20:06 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:39150 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbXKVCUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 21:20:05 -0500
Date: Wed, 21 Nov 2007 21:20:04 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Al Niessner <Al.Niessner@jpl.nasa.gov>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where is the interrupt going?
Message-ID: <20071122022004.GB9265@fattire.cabal.ca>
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 05:08:30PM -0800, Al Niessner wrote:
> On with the detailed technical information. I developed a kernel module
> for an PCI card back in 2.4, moved it to 2.6.3, then 2.6.11 or so and
> now I am trying to move it to 2.6.22. When I began the to move to
> 2.6.22, I changed all of the deprecated calls for finding the card on
> the PCI bus, modified the interrupt handler prototype, and changed my
> readvv/writev to aio_read/aio_write following
> http://lwn.net/Articles/202449/. So initialization looks like this:
> 

Hi Al,

>From the sounds of it, you might have an interrupt routing problem. Can
you describe the machine you have this plugged into? Possibly attaching
a copy of "dmesg" and "/proc/interrupts"?

Feel free to attach the driver source to your email if the size is
reasonable (which it sounds like it is.)

As a "big hammer" in case it is an APIC problem, please try booting the
kernel with the "noapic" parameter.

cheers,
	Kyle
