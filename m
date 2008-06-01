Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbYFASN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbYFASN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 14:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYFASNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 14:13:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbYFASNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 14:13:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: s2ram video problems Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Date: Sun, 1 Jun 2008 20:14:00 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, tytso@mit.edu,
       benh@kernel.crashing.org,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, seife@suse.de
References: <20080529124548.GC8065@mit.edu> <20080601162150.GC5555@ucw.cz> <1212343465.3373.60.camel@localhost.localdomain>
In-Reply-To: <1212343465.3373.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806012014.01765.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 1 of June 2008, James Bottomley wrote:
> On Sun, 2008-06-01 at 18:21 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > Fix NOHZ/CPUIDLE along with suspend/resume on all participants
> > > > laptops, which are probably 50+ different models. That'd be an odd
> > > > enough mix of wreckaged hardware / BIOS / ACPI.
> > > > 
> > > > Should be fun and solve a bunch of hard to grok bugs in the bugzillas
> > > > along the way.
> > > 
> > > Well ... in theory.
> > > 
> > > In practice, for instance, my laptop had suspend/resume working shortly
> > > after I got it, and the widescreen video too.  Most of the problems were
> > > video related, so I did interact with the upstream intel video driver
> > > people, but by and large it was a set of black magic rules to restore
> > > the video to its prior state (in my case, even the vbe tools didn't work
> > > and I had to manually save and restore the pci config space).
> > 
> > that's s2ram -v, right? Can you submit a whitelist entry so it starts
> > working for other people, too?
> 
> Actually, it's pm-utils, because I'm using fedora.
> 
> This, by the way was years ago, beginning with FC6.  In FC7 we got the
> driver to the state where vbestate save/restore worked for it and added
> it to the hal database.  Today, at FC9, I've just been busy filing a bug
> with fedora because the i915 drm now seems to do everything and actively
> screws up if vbestate save/restore is used (so all the work I did with
> FC7/8 now needs to be undone).

Well, we have the same problem in s2ram.

Thanks,
Rafael
