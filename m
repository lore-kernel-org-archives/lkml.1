Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbYFZUcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbYFZUcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYFZUc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:32:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33028 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbYFZUc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:32:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] Remove obsolete piece of PM documentation
Date: Thu, 26 Jun 2008 22:34:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <200806121025.24668.rjw@sisk.pl> <20080612205118.GB11761@elf.ucw.cz> <alpine.LFD.1.10.0806261535140.2988@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0806261535140.2988@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806262234.09104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 of June 2008, Len Brown wrote:
> 
> > > > > > -               Linux Power Management Support
> > > > > > -
> > > > > > -This document briefly describes how to use power management with your
> > > > > > -Linux system and how to add power management support to Linux drivers.
> > > > > > -
> > > > > > -APM or ACPI?
> > > > > > -------------
> > > > > > -If you have a relatively recent x86 mobile, desktop, or server system,
> > > > > > -odds are it supports either Advanced Power Management (APM) or
> > > > > > -Advanced Configuration and Power Interface (ACPI).  ACPI is the newer
> > > > > > -of the two technologies and puts power management in the hands of the
> > > > > > -operating system, allowing for more intelligent power management than
> > > > > > -is possible with BIOS controlled APM.
> > > > > > -
> > > > > > -The best way to determine which, if either, your system supports is to
> > > > > > -build a kernel with both ACPI and APM enabled (as of 2.3.x ACPI is
> > > > > > -enabled by default).  If a working ACPI implementation is found, the
> > > > > > -ACPI driver will override and disable APM, otherwise the APM driver
> > > > > > -will be used.
> > > > > > -
> > > > > > -No, sorry, you cannot have both ACPI and APM enabled and running at
> > > > > > -once.  Some people with broken ACPI or broken APM implementations
> > > > > > -would like to use both to get a full set of working features, but you
> > > > > > -simply cannot mix and match the two.  Only one power management
> > > > > > -interface can be in control of the machine at once.  Think about it..
> > > > > 
> > > > > I'd keep this; it is still true, and we still support both.
> > > > > 
> > > > > Maybe it should be moved into Doc*/power/apm.txt or something.
> > > > 
> > > > Yes, if there is a good sub-directory for it, please put it there.
> 
> I think this is already covered in the Kconfig help for ACPI and APM
> and doesn't need a Documentation file.

It won't hurt to have the file, though.

I have reworked the patch already and I'd rather not do that again the other
way around. ;-)

Thanks,
Rafael
