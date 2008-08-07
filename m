Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYHGVfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYHGVfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYHGVex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:34:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52335 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYHGVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:34:52 -0400
Subject: Re: [PATCH 6/7] pm: Config option to disable handling of console
 during suspend/resume
From: Ben Collins <ben.collins@canonical.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20080804062823.GA22015@atrey.karlin.mff.cuni.cz>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
	 <E1KKl4J-00068V-6f@swissweb.swissdisk.com>
	 <20080729033309.GB12085@kroah.com> <200807292315.36511.rjw@sisk.pl>
	 <1217368310.6066.56.camel@cunning> <20080730044716.GA2954@kroah.com>
	 <1217427607.5976.104.camel@cunning>
	 <20080804062823.GA22015@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 07 Aug 2008 17:23:18 -0400
Message-Id: <1218144198.10040.196.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.6 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 08:28 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > index e7bea3e..6a042f8 100644
> > > > --- a/Documentation/kernel-parameters.txt
> > > > +++ b/Documentation/kernel-parameters.txt
> > > > @@ -2247,6 +2247,11 @@ and is between 256 and 4096 characters. It is defined in the file
> > > >  	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
> > > >  			Format: <command>
> > > >  
> > > > +	vt_switch=	[PM] Switch vt's during suspend/resume
> > > > +			Format: { 0 | 1 }
> > > > +			Default is normally '1', but depends on value of
> > > > +			the PM_DISABLE_CONSOLE config option.
> > > > +
> > > 
> > > Why a build time config option?  Why not just set the command line
> > > option if you need this?  And/or make it a sysctrl?
> > > 
> > > That way we don't have to add yet-another-config-option for distros and
> > > users to get wrong.
> > > 
> > > thanks,
> > 
> > Sysctl makes sense. I would rather not have to add a cmdline option to
> > default installs (and on upgrades). I'll redo the patch that way and
> > resend.
> 
> Maybe have acpi_sleep=no_vt_switch? THat is already settable from
> userspace...?

Where is this setting?
									Pavel

