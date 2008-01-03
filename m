Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYACVjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYACVjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYACVjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:39:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49352 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYACVjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:39:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Date: Thu, 3 Jan 2008 22:41:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pavel@suse.cz, linux-kernel@vger.kernel.org
References: <20080103442.621670000@suse.de> <200801031822.02668.rjw@sisk.pl> <200801031842.49668.ak@suse.de>
In-Reply-To: <200801031842.49668.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801032241.29218.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of January 2008, Andi Kleen wrote:
> 
> > > +config PM_CPUINIT
> > > +	bool
> > > +	depends on PM
> > 
> > Please make it PM_SLEEP (PM is more than suspend/hibernation).
> 
> That was something that irritated me too while writing the patch, but the functions I 
> am interested in with this  are referenced from arch/x86/power/cpu.c and that is
> 
> obj-$(CONFIG_PM)                += cpu.o
> 
> So you would need to fix that first. Would be fine for me, but is out of scope for
> my patch.

OK, I'll fix that up later.

Thanks,
Rafael
