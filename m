Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbYHDGqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbYHDGqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYHDGqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:46:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36573 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYHDGqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:46:34 -0400
Date: Mon, 4 Aug 2008 08:28:23 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ben Collins <ben.collins@canonical.com>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 6/7] pm: Config option to disable handling of console during suspend/resume
Message-ID: <20080804062823.GA22015@atrey.karlin.mff.cuni.cz>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com> <E1KKl4J-00068V-6f@swissweb.swissdisk.com> <20080729033309.GB12085@kroah.com> <200807292315.36511.rjw@sisk.pl> <1217368310.6066.56.camel@cunning> <20080730044716.GA2954@kroah.com> <1217427607.5976.104.camel@cunning>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217427607.5976.104.camel@cunning>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > index e7bea3e..6a042f8 100644
> > > --- a/Documentation/kernel-parameters.txt
> > > +++ b/Documentation/kernel-parameters.txt
> > > @@ -2247,6 +2247,11 @@ and is between 256 and 4096 characters. It is defined in the file
> > >  	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
> > >  			Format: <command>
> > >  
> > > +	vt_switch=	[PM] Switch vt's during suspend/resume
> > > +			Format: { 0 | 1 }
> > > +			Default is normally '1', but depends on value of
> > > +			the PM_DISABLE_CONSOLE config option.
> > > +
> > 
> > Why a build time config option?  Why not just set the command line
> > option if you need this?  And/or make it a sysctrl?
> > 
> > That way we don't have to add yet-another-config-option for distros and
> > users to get wrong.
> > 
> > thanks,
> 
> Sysctl makes sense. I would rather not have to add a cmdline option to
> default installs (and on upgrades). I'll redo the patch that way and
> resend.

Maybe have acpi_sleep=no_vt_switch? THat is already settable from
userspace...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

