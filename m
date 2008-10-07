Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbYJGVXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbYJGVXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758509AbYJGVWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:22:54 -0400
Received: from kroah.org ([198.145.64.141]:45144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758501AbYJGVWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:22:52 -0400
Date: Tue, 7 Oct 2008 14:19:05 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
       Shem Multinymous <multinymous@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Message-ID: <20081007211905.GB8151@kroah.com>
References: <48C7FCEE.8060404@kernel.org> <20080917180405.GB3162@kroah.com> <20080918111845.GH27832@elf.ucw.cz> <200809191104.00171.trenn@suse.de> <20080924051417.GA29993@kroah.com> <20081007204011.GG6604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007204011.GG6604@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 10:40:11PM +0200, Pavel Machek wrote:
> 
> > > > > Code created by access to specs that were not allowed to be published in
> > > > > GPL form by someone who wants to remain anonymous.
> > > >
> > > > That anonymous person may have problems if they signed NDA.
> > > >
> > > > I don't think they did, they even list the sources:
> > > >
> > > >  *  The embedded controller on ThinkPad laptops has a non-standard
> > > > interface, *  where LPC channel 3 of the H8S EC chip is hooked up to IO
> > > > ports *  0x1600-0x161F and implements (a special case of) the H8S LPC
> > > > protocol. *  The EC LPC interface provides various system management
> > > > services (currently *  known: battery information and accelerometer
> > > > readouts). This driver *  provides access and mutual exclusion for the EC
> > > > interface.
> > > > *
> > > >  *  The LPC protocol and terminology is documented here:
> > > >  *  "H8S/2104B Group Hardware Manual",
> > > >  * 
> > > > http://documentation.renesas.com/eng/products/mpumcu/rej09b0300_2140bhm.pdf
> > > >
> > > > H8S chip seems to be documented.
> > > Hmm, the EC is not directly used, but ACPI functions of the HP device are 
> > > used.
> > > For the HP ACPI device: the ACPI functions can *very easily* be re-engineered
> > > (which is common for all laptop_acpi.ko drivers):
> > > ALRD -> is used by the driver to read out registers of the accelerometer
> > > ALWR -> is used by the driver to write a registers of the accelerometer
> > > BTW: HP likes to have support for their device.
> > > 
> > > The acceleromter chip itself is docuemented in detail here:
> > > http://www.st.com/stonline/products/literature/ds/12094/lis3lv02dl.pdf
> > > 
> > > I also do not see any concerns.
> > > Greg: Can you please add this one or explain in more detail what else you like 
> > > to see to get this integerated.
> > 
> > If you, or anyone else, writes a new driver from the published
> > documents, that driver can be accepted.  It can not be based on the
> > existing code written by Shem in any form.
> 
> Can you detail what "published" means?

Published in a way that has NOTHING to do with these source files.

> Either I can take his sources on sourceforge.net (quite well known
> place, right) as published information, or I could not use other well
> known sources such as wikipedia.

If the wikipedia information was written based on these source files,
no, we can't use that, sorry.

> Sources on sourceforge.net seem published-enough to me, and if you
> insist they can't be used, you should provide some reasons...
> 
> [And no, just calling it "tainted" is not enough.]

{sigh}

Again, for the last time:
  - this code was written by an anonymous person, using documents or
    information that was obtained and used in a manner that was not
    legal according to their employment agreement.
  - because of this, we can not use this code, because we KNOW the
    information was obtained in a improper manner.
  - so, to get something like this into the kernel, we need to rewrite
    the code, using information obtained LEGALLY from either the
    manufacturer of the chips or computers, or from another TOTALLY
    SEPARATE location.

Does that help explain this?

thanks,

greg k-h
