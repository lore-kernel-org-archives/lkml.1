Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0BBJ72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:59:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58881 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098Ab0BBJ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 04:59:22 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
In-Reply-To: <20100202042402.GJ13428@linux-sh.org>
References: <20100202042402.GJ13428@linux-sh.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 09:58:58 +0000
Message-Id: <1265104738.12634.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 09:58:59.0755 (UTC) FILETIME=[576967B0:01CAA3EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 04:24 +0000, Paul Mundt wrote:
> On Mon, Feb 01, 2010 at 03:14:04PM -0500, Alan Stern wrote:
> > On Mon, 1 Feb 2010, Catalin Marinas wrote:
> >
> > > On Fri, 2010-01-29 at 18:54 +0000, Matthew Dharm wrote:
> > > > HOWEVER, I firmly believe that the cache-management functions belong with
> > > > the driver that actually talks to the low-level hardware, as that's the
> > > > only place where you can be 100% certain of what cache operations are
> > > > needed.  After all, I think someone is working on a USB-over-IP transport,
> > > > and trying to manage cache at the usb-storage level in that scenario is
> > > > just silly.
> > > >
> > > > So, let's put this in the HCD drivers and be done with it.
> > >
> > > The patch below is what fixes the I-D cache incoherency issues on ARM. I
> > > don't particularly like the solution but it seems to be the only one
> > > available.
> > >
> > > IMHO, Linux should have functions similar to the DMA API but for PIO
> > > drivers (e.g. pio_map_single/pio_unmap_single) that non-coherent
> > > architectures can define, otherwise being no-ops. Any thoughts?
> >
> > You should bring this up on the linux-arm-kernel mailing list and CC: 
> > the ARM maintainer.  They are the ones most directly affected.
> 
> No, this belongs on linux-arch, as it's something that impacts a lot of
> people besides ARM.

I agree. I'll try to come up with a proposal and post it there.

BTW, this was already raised on the ARM Linux lists and people there are
aware of these problems. Their suggestion was to take it to LKML.

-- 
Catalin

