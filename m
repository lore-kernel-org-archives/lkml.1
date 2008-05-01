Return-Path: <linux-kernel-owner+w=401wt.eu-S1762464AbYEAQJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762464AbYEAQJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYEAQJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:09:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53924 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYEAQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:09:25 -0400
Date: Thu, 1 May 2008 18:09:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to
	ram
Message-ID: <20080501160946.GA26089@elf.ucw.cz>
References: <4818D9AB.3040402@googlemail.com> <200805010157.58607.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805010157.58607.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The ICH9 apparently provides a pair of memory mapped on-die thermal sensors.
> 
> The sensors basically shut off your hardware if it gets too hot.

Are the sensors driven by ACPI? Probably yes, otherwise they would be
unable to shut down the system.

> ICH9 exports the base address for the sensors via a PCI device -- D31:F6, aka Linux 00:1f.6
> 
> I'm not aware of a native Linux device driver that talks to this device
> (nor can I think of a useful purpose for such a driver)
> So it seems what is in play here is any BIOS code that talks to this device,
> and Linux's standard PCI config space restore.
> 
> My guess is that the BIOS is enabling the device on cold boot,
> but not enabling it after resume from S3.

That sounds like a BIOS problem, right? If the piece of hardware is
driven by BIOS, Linux can't be responsible for saving/restoring it.
 									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
