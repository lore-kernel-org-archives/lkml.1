Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZF0L1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZF0L1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZF0L1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:27:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40813 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbZF0L1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:27:34 -0400
Date: Wed, 24 Jun 2009 17:03:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090624150309.GD1784@ucw.cz>
References: <20090608130509.GA3272@elte.hu> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <20090608133215.GA15482@srcf.ucam.org> <20090608134647.GA14234@elte.hu> <20090608135431.GA16052@srcf.ucam.org> <20090608142450.GE14234@elte.hu> <20090608143513.GB16752@srcf.ucam.org> <20090608144455.GA20905@elte.hu> <20090608145102.GA17427@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608145102.GA17427@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > [...] Yes, we can greatly expand the userland-visible interface to 
> > > every piece of hardware in order to make this work, but that's a 
> > > huge amount of effort to avoid a model where userspace sets some 
> > > tunables appropriately.
> > 
> > What huge amount of effort? All you are doing is to track the "is 
> > the device really used" state in user-space - and, if the current 
> > desktop experience is any measure, highly imperfectly so.
> > 
> > What i'm suggesting is to track it properly in the kernel. It's not 
> > like the kernel doesnt need to know whether a piece of hardware is 
> > under use or not ...
> 
> So, for instance, we need to add interfaces like "I care about hotplug 
> events on this SATA port" and "I'm listening for these keys so please 
> don't suspend the device" and "The service bound to this port needs to 
> maintain network connectivity and the one bound to this port doesn't, so 
> only put the wireless card into deep powersave if the first exits", and 
> then we need to wait for userspace to adopt these interfaces before we 
> can enable any of the functionality because otherwise old userspace will 
> be broken with new kernels.

Yes, that's the way to go. It is not particulary easy way, but at
least such userspace will work with upcoming hardware and kernel will
be able to get features such as 'system autosuspend'...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
