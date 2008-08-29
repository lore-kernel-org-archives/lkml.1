Return-Path: <linux-kernel-owner+w=401wt.eu-S1751018AbYH2PaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbYH2PaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYH2P34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:29:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbYH2P34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:29:56 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Date: Fri, 29 Aug 2008 17:29:52 +0200
User-Agent: KMail/1.9.9
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807241732.23412.trenn@suse.de> <200808281416.57193.trenn@suse.de> <20080828122227.GA26285@srcf.ucam.org>
In-Reply-To: <20080828122227.GA26285@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291729.53628.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 14:22:29 Matthew Garrett wrote:
> On Thu, Aug 28, 2008 at 02:16:55PM +0200, Thomas Renninger wrote:
> > On Thursday 28 August 2008 12:56:16 Matthew Garrett wrote:
> > > A documented WMI interface is easier to use than an entirely custom
> > > documented interface, and reduces the amount of work the vendor has to
> > > do in Windows. To be honest, I think it's the sort of thing we should
> > > be encouraging.
> >
> > IMO WMI should not exist.
> > A lot laptop BIOSes do not use it at all, unfortunately it seems to get
> > more common again.
> > What advantage do you get on Linux using WMI?
>
> Little. But what advantage do we get in the same functionality being
> implemented in an entirely custom way? Even less.
It is all about documentation, right.
WMI is complicating things by one needless and complicated layer.

> > For example HP is using WMI to export a WLAN (or bluetooth?) button on
> > some machines.
> > They should not do that, right?
>
> The HP wlan button is a hardware event. There's no need for it to be
> sent via the keyboard controller. Some of the other keys would be easier
> to deal with if they were sent via the keyboard controller, yes, but
> that's not the full set of what the WMI functionality gives us. How do
> you want kill switches to be controlled? I'd be happier with it being
> done through WMI (like HP) than via Dell's bizarro SMI interface.
>
> > AFAIK most vendors tend to send an ordinary key event again for most
> > extra buttons. Is this the way to go for the future? This probably
> > should also be mentioned then.
>
> Some vendors do, and I agree that it's preferable.

Feel free to send text snippets, e.g. about the preferable way of key events.
Best a diff against the .tex file, but I can do the work and integrate it, np.

Thanks,

      Thomas
