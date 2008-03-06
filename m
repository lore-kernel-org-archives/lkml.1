Return-Path: <linux-kernel-owner+w=401wt.eu-S935047AbYCFUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047AbYCFUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762248AbYCFUvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:51:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:52455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762895AbYCFUvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:51:46 -0500
Date: Thu, 6 Mar 2008 12:51:30 -0800
From: Greg KH <gregkh@suse.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080306205130.GA32747@suse.de>
References: <200803030316.07165.rjw@sisk.pl> <20080306072704.GA28518@elte.hu> <Pine.LNX.4.64.0803062054110.8669@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803062054110.8669@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 08:55:25PM +0100, Guennadi Liakhovetski wrote:
> On Thu, 6 Mar 2008, Ingo Molnar wrote:
> 
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
> > > Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3) kernels
> > > Submitter	: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Date		: 2008-02-27 08:15
> > 
> > Guennadi bisected this down to:
> > 
> >   commit fd7d1ced29e5beb88c9068801da7a362606d8273
> >   PCI: make pci_bus a struct device
> > 
> > and it's suspected that Andrew's poweroff problems might be related as 
> > well. Guennadi, Andrew, find below a manual revert of this change - does 
> > it make any difference?
> 
> Yes, this patch fixes both startup warnings and lets the system reboot and 
> power off again!

Ok, I think we have two different problems here (as andrew showed.)

I'll work with Guennadi on his issue for now, as the pci patch shows
there is still an issue here.

thanks,

greg k-h
