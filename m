Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbXEVWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbXEVWBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765530AbXEVWA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:00:57 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:32976 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764324AbXEVWA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:00:56 -0400
Date: Tue, 22 May 2007 15:00:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the
	-stable cycle
Message-ID: <20070522220044.GB3429@sequoia.sous-sol.org>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522193538.GA885@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Tue, May 22, 2007 at 03:04:08PM -0400, Jeff Garzik wrote:
> >  Really, it is just silly to think that one-line PCI IDs patches will cause 
> >  any harm at all, and it should be self-evident that there is clear potential 
> >  to HELP Linux users.  That's why we're all here, right?

Yes, we're here to help.  The only compelling reasons not do to it were/are:

1) -stable has never been about adding features (easy to consider new
hardware support a feature).

2) In theory new hardware can seem to work with a simple PCI ID
update, and later we find it needs extra quirk handling or specific
driver support.  This could mean adding buggy support for new hardware
to -stable.  In practice, hopefully this isn't a real issue.

3) It hasn't been a pressing issue brought to our attention until this
thread and its predecessor earlier in the month.

My own personal experience is each time I've needed a PCI ID update for
new hardware it's also needed changes to the driver (read: e1000, every
single time).  So from my perspective neither sysfs nor relaxing -stable
rules slightly would actually help provide support for new hardware,
but that's clearly limited experience.

> I'm not disagreeing that it will help a set of users, or that it will
> cause any harm at all.  It's just currently outside the scope for what
> we defined -stable as, and it will slightly increase the workload that
> Chris and I have in keeping up with these patches.
> 
> So, if there is an overwhelming majority of people that strongly feel
> that this is a good thing, fine, we can try it out.

Yes, if it will serve -stable users better, we can give it a trial run
to see how it goes.

thanks,
-chris
