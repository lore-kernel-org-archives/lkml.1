Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYFZToP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYFZToP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763135AbYFZTk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:40:58 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:36885 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbYFZTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:40:54 -0400
Date: Thu, 26 Jun 2008 15:40:19 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] Remove obsolete piece of PM documentation
In-reply-to: <20080612205118.GB11761@elf.ucw.cz>
X-X-Sender: lenb@localhost.localdomain
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806261535140.2988@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200806121025.24668.rjw@sisk.pl> <20080612131253.GD5455@ucw.cz>
 <16803397.1213285081959.JavaMail.oracle@acsmt301.oracle.com>
 <200806122248.59621.rjw@sisk.pl> <20080612205118.GB11761@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > > > > -               Linux Power Management Support
> > > > > -
> > > > > -This document briefly describes how to use power management with your
> > > > > -Linux system and how to add power management support to Linux drivers.
> > > > > -
> > > > > -APM or ACPI?
> > > > > -------------
> > > > > -If you have a relatively recent x86 mobile, desktop, or server system,
> > > > > -odds are it supports either Advanced Power Management (APM) or
> > > > > -Advanced Configuration and Power Interface (ACPI).  ACPI is the newer
> > > > > -of the two technologies and puts power management in the hands of the
> > > > > -operating system, allowing for more intelligent power management than
> > > > > -is possible with BIOS controlled APM.
> > > > > -
> > > > > -The best way to determine which, if either, your system supports is to
> > > > > -build a kernel with both ACPI and APM enabled (as of 2.3.x ACPI is
> > > > > -enabled by default).  If a working ACPI implementation is found, the
> > > > > -ACPI driver will override and disable APM, otherwise the APM driver
> > > > > -will be used.
> > > > > -
> > > > > -No, sorry, you cannot have both ACPI and APM enabled and running at
> > > > > -once.  Some people with broken ACPI or broken APM implementations
> > > > > -would like to use both to get a full set of working features, but you
> > > > > -simply cannot mix and match the two.  Only one power management
> > > > > -interface can be in control of the machine at once.  Think about it..
> > > > 
> > > > I'd keep this; it is still true, and we still support both.
> > > > 
> > > > Maybe it should be moved into Doc*/power/apm.txt or something.
> > > 
> > > Yes, if there is a good sub-directory for it, please put it there.

I think this is already covered in the Kconfig help for ACPI and APM
and doesn't need a Documentation file.

-Len

