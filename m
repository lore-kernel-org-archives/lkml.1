Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZK2ARm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZK2ARm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 19:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZK2ARl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 19:17:41 -0500
Received: from kroah.org ([198.145.64.141]:47242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbZK2ARk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 19:17:40 -0500
Date: Sat, 28 Nov 2009 16:17:45 -0800
From: Greg KH <greg@kroah.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Robert Hancock <hancockrwd@gmail.com>, Mikhail Malygin <mmalygin@ked.de>,
       Hans Werner <hwerner4@gmx.de>, Tejun Heo <tj@kernel.org>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix
	FailSafe issue?
Message-ID: <20091129001745.GA29143@kroah.com>
References: <20091126164212.GA24421@sig21.net> <20091128191932.GB24048@kroah.com> <4B11886E.3030906@gmail.com> <20091128213446.GA26420@kroah.com> <20091128222203.GA369@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091128222203.GA369@sig21.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 11:22:03PM +0100, Johannes Stezenbach wrote:
> > Seriously.  It's a BIOS issue, and is the way that Samsung has
> > implemented this.  There is nothing that the OS can do about it.
> > Windows has the same "issue" here.
> 
> Um, "how does Windows handle this" would've been my next question.
> I didn't do much with Windows before I wiped it, I mainly used it
> to confirm the thing works and to do the BIOS update. I did go through
> a few reboot cycles though and I think I would've noticed a 30 second
> hang. Maybe they just lowered the ATA timeout to hide it or something.
> Otherwise I guess google would turn up complaints from Windows users, too,
> not just from Linux users.
> 
> BTW, at 5min after boot it is 99% guaranteed that this ATA
> exception will happen during the occasional fsck. That
> doesn't feel right.

Well, I've never been doing a fsck at 5 minutes into boot, and neither do
most Windows users :)

> > I do not disagree with you at all about this.  This has been
> > communicated to Samsung, but at this point in time, they are not going
> > to support ACPI and only want Linux to use this interface.
> 
> Well, at least they made the information for the SECLINUX interface
> available (to you),

You have as much information for the SECLINUX interface that I do at
this point in time.  It is all documented in the driver.  Actually, it's
documented better in the driver than the "hints" they originally
provided me...

> but it would be better they'd support ACPI.
> I mean if they have to support it for Windows 7 anyway, then
> what's the point of not supporting it for other OSs?

Hey, no argument from me here, but I think the main issue is that they
do not officially support Windows 7 on this platform yet either.  Hence,
no ACPI support.  The ACPI support in the latest BIOS seems very rough,
I think this is the first time they have ever implemented ACPI, so I
would not count on it working properly just yet.

> While were at it I have another question:  When running on battery the
> ethernet throughput drops to ~25Mbit/s.  After a bit of experimenting
> I found that this is connected to a BIOS entry about "CPU Power
> Saving Mode".  lspci shows that this changes "LnkCtl: ASPM L1
> Enabled" to "LnkCtl: ASPM L0s L1 Enabled".  Having this config
> option in the BIOS is inflexible.  IIRC there was an app in
> Windows which allows to configure it at runtime.  Do you
> know how to do it in Linux?

I do not konw anything about this.  Are you saying that Windows would
allow you to turn the throughput back up at the expense of battery life
through an application?  Do you know what that application is called and
where I could find it?

thanks,

greg k-h
