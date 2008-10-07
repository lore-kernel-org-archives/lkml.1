Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYJGUio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYJGUio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbYJGUie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:38:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35351 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYJGUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:38:34 -0400
Date: Tue, 7 Oct 2008 22:40:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
       Shem Multinymous <multinymous@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Message-ID: <20081007204011.GG6604@elf.ucw.cz>
References: <48C7FCEE.8060404@kernel.org> <20080917180405.GB3162@kroah.com> <20080918111845.GH27832@elf.ucw.cz> <200809191104.00171.trenn@suse.de> <20080924051417.GA29993@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924051417.GA29993@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > Code created by access to specs that were not allowed to be published in
> > > > GPL form by someone who wants to remain anonymous.
> > >
> > > That anonymous person may have problems if they signed NDA.
> > >
> > > I don't think they did, they even list the sources:
> > >
> > >  *  The embedded controller on ThinkPad laptops has a non-standard
> > > interface, *  where LPC channel 3 of the H8S EC chip is hooked up to IO
> > > ports *  0x1600-0x161F and implements (a special case of) the H8S LPC
> > > protocol. *  The EC LPC interface provides various system management
> > > services (currently *  known: battery information and accelerometer
> > > readouts). This driver *  provides access and mutual exclusion for the EC
> > > interface.
> > > *
> > >  *  The LPC protocol and terminology is documented here:
> > >  *  "H8S/2104B Group Hardware Manual",
> > >  * 
> > > http://documentation.renesas.com/eng/products/mpumcu/rej09b0300_2140bhm.pdf
> > >
> > > H8S chip seems to be documented.
> > Hmm, the EC is not directly used, but ACPI functions of the HP device are 
> > used.
> > For the HP ACPI device: the ACPI functions can *very easily* be re-engineered
> > (which is common for all laptop_acpi.ko drivers):
> > ALRD -> is used by the driver to read out registers of the accelerometer
> > ALWR -> is used by the driver to write a registers of the accelerometer
> > BTW: HP likes to have support for their device.
> > 
> > The acceleromter chip itself is docuemented in detail here:
> > http://www.st.com/stonline/products/literature/ds/12094/lis3lv02dl.pdf
> > 
> > I also do not see any concerns.
> > Greg: Can you please add this one or explain in more detail what else you like 
> > to see to get this integerated.
> 
> If you, or anyone else, writes a new driver from the published
> documents, that driver can be accepted.  It can not be based on the
> existing code written by Shem in any form.

Can you detail what "published" means?

Either I can take his sources on sourceforge.net (quite well known
place, right) as published information, or I could not use other well
known sources such as wikipedia.

Sources on sourceforge.net seem published-enough to me, and if you
insist they can't be used, you should provide some reasons...

[And no, just calling it "tainted" is not enough.]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
