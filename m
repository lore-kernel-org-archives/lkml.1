Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYGBWTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYGBWTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYGBWTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:19:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYGBWTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:19:05 -0400
Date: Wed, 2 Jul 2008 15:15:17 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nathan Lynch <ntl@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Removing sysdevs?
Message-ID: <20080702221517.GA17929@kroah.com>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <486B9B3A.4060709@firstfloor.org> <20080702185145.GB20938@kroah.com> <200807022341.44965.rjw@sisk.pl> <20080702214853.GA10451@kroah.com> <486BF9AC.6070704@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486BF9AC.6070704@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 11:57:00PM +0200, Andi Kleen wrote:
> 
> > The plan is:
> > 	- remaining driver core cleanups to allow for multiple drivers
> > 	  to be bound to individual devices
> > 	- add multiple binding support to the core
> > 	- migrate existing sysdevs to struct device, now that multiple
> > 	  binding is allowed
> > 	- delete sysdev structure
> > 	- profit!
> 
> I hope the sysdev semantics of running with interrupts etc. will be kept?

Yes, all of the current semantics should be kept.

> > It's that first step that is taking a while, the last big changes will
> > be going into 2.6.27 to help accomplish this, after that merge happens
> > for 2.6.27-rc1 I'll be working on the remaining steps.
> 
> So what's up with the sysdev attribute passing changes i posted? Are you
> going to put them in or will the conversion happen so soon that they're
> not worth it?
> 
> I eventually need the passed attribute for the dynamic bank patches.

Sorry, was side tracked by other work today.

The patches look fine, do you want me to take them through my tree, or
do you want to have them go through somewhere else as you have some
dependancies on them?

If somewhere else, that's fine with me, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to them.

thanks,

greg k-h
