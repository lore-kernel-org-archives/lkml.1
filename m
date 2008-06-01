Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYFASEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYFASEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 14:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYFASEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 14:04:34 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50988 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbYFASEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 14:04:33 -0400
Subject: Re: s2ram video problems Re: [Ksummit-2008-discuss] Fixing the
	Kernel Janitors project
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       tytso@mit.edu, benh@kernel.crashing.org,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, seife@suse.de
In-Reply-To: <20080601162150.GC5555@ucw.cz>
References: <20080529124548.GC8065@mit.edu>
	 <20080529.135431.235149338.davem@davemloft.net>
	 <20080529211404.GH8065@mit.edu>
	 <20080529.143921.34376298.davem@davemloft.net>
	 <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de>
	 <1212330249.3373.20.camel@localhost.localdomain>
	 <20080601162150.GC5555@ucw.cz>
Content-Type: text/plain
Date: Sun, 01 Jun 2008 13:04:25 -0500
Message-Id: <1212343465.3373.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-01 at 18:21 +0200, Pavel Machek wrote:
> Hi!
> 
> > > Fix NOHZ/CPUIDLE along with suspend/resume on all participants
> > > laptops, which are probably 50+ different models. That'd be an odd
> > > enough mix of wreckaged hardware / BIOS / ACPI.
> > > 
> > > Should be fun and solve a bunch of hard to grok bugs in the bugzillas
> > > along the way.
> > 
> > Well ... in theory.
> > 
> > In practice, for instance, my laptop had suspend/resume working shortly
> > after I got it, and the widescreen video too.  Most of the problems were
> > video related, so I did interact with the upstream intel video driver
> > people, but by and large it was a set of black magic rules to restore
> > the video to its prior state (in my case, even the vbe tools didn't work
> > and I had to manually save and restore the pci config space).
> 
> that's s2ram -v, right? Can you submit a whitelist entry so it starts
> working for other people, too?

Actually, it's pm-utils, because I'm using fedora.

This, by the way was years ago, beginning with FC6.  In FC7 we got the
driver to the state where vbestate save/restore worked for it and added
it to the hal database.  Today, at FC9, I've just been busy filing a bug
with fedora because the i915 drm now seems to do everything and actively
screws up if vbestate save/restore is used (so all the work I did with
FC7/8 now needs to be undone).

James


