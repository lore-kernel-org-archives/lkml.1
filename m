Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYFLVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYFLVhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYFLVg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:36:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34404 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYFLVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:36:56 -0400
Message-ID: <4053695.1213306175480.JavaMail.oracle@web241.oracle.com>
Date: Thu, 12 Jun 2008 21:29:35 +0000 (GMT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 4/4] Remove obsolete piece of PM documentation
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Original Message ---
> On Thu 2008-06-12 22:48:58, Rafael J. Wysocki wrote:
> > On Thursday, 12 of June 2008, Randy Dunlap wrote:
> > > --- Original Message ---
> > > > On Thu 2008-06-12 10:31:38, Rafael J. Wysocki wrote:
> > > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > 
> > > > > Remove an obsolete piece of PM documentation.
> > > > > 
> > > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > ---
> > > > >  Documentation/power/pm.txt |  257 ---------------------------------------------
> > > > >  1 file changed, 257 deletions(-)
> > > > > 
> > > > > Index: linux-2.6/Documentation/power/pm.txt
> > > > > ===================================================================
> > > > > --- linux-2.6.orig/Documentation/power/pm.txt
> > > > > +++ /dev/null
> > > > > @@ -1,257 +0,0 @@
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
> > > 
> > > > ACK on rest.
> > 
> > Updated patch is appended.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Remove some obsolete PM documentation.
> > 
> > The majority of contents of Documentation/power/pm.txt are
> > outdated.  Remove the outdated parts of this file and move the rest
> > to Documentation/power/apm-acpi.txt .  Update the index in
> > Documentation/power/ as appropriate.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> ACK and thanks.

Same here.

~Randy

