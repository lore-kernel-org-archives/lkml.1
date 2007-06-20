Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbXFTHAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbXFTHAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbXFTHAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:00:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:53388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150AbXFTHAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:00:15 -0400
Date: Tue, 19 Jun 2007 23:58:17 -0700
From: Greg KH <gregkh@suse.de>
To: Paulo Pereira <pfmp.404@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/2] 2.6.22-rc4: known regressions with patches v3
Message-ID: <20070620065817.GC13359@suse.de>
References: <Pine.LNX.4.44L0.0706131659570.13726-100000@iolanthe.rowland.org> <200706190948.27710.pfmp.404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706190948.27710.pfmp.404@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 09:48:27AM +0100, Paulo Pereira wrote:
> A Wednesday 13 June 2007 22:01:54, Alan Stern escreveu:
> > On Wed, 13 Jun 2007, Greg KH wrote:
> > > On Wed, Jun 13, 2007 at 09:58:05PM +0200, Michal Piotrowski wrote:
> > > >  USB
> > > >
> > > >  Subject    : list_add corruption. prev->next should be next
> > > > (f7d28794), but was f0df8ed4 (prev=f0df8ed4) Kernel Bug at
> > > > lib/list_debug.c:33 References :
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=8561
> > > >  Submitter  : Paulo Pereira <pfmp.404@gmail.com>
> > > >  Handled-By : Alan Stern <stern@rowland.harvard.edu>
> > > >  Patch      : http://bugzilla.kernel.org/show_bug.cgi?id=8561#c8
> > > >  Status     : patch was suggested
> > >
> > > I'm pretty sure this wasn't a "regression" and was always there, and
> > > that the proposed patch did fix the solution, right Paulo and Alan?
> >
> > I'm also pretty sure that it's not a regression and that the patch
> > should have fixed it.  But since Paolo hasn't replied to any of our
> > queries, we can't be certain.
> >
> > Alan Stern
> 
> Hi, I'am writting for tell that the patch work well, I have Ktorrent working 
> for 3 days and there is no Kernel Panic!!!! But I'am using Kernel 2.6.22-rc4 
> with the patch that you send!!

Ok, it's queued up for after 2.6.22 is out as it is not a regression and
is kind of intrusive.

Unless others think it should go in now?

thanks,

greg k-h
