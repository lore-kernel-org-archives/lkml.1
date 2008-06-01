Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbYFARyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbYFARyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 13:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYFARyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 13:54:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYFARyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 13:54:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: s2ram video problems Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Date: Sun, 1 Jun 2008 19:55:04 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, tytso@mit.edu,
       benh@kernel.crashing.org,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, seife@suse.de
References: <20080529124548.GC8065@mit.edu> <1212330249.3373.20.camel@localhost.localdomain> <20080601162150.GC5555@ucw.cz>
In-Reply-To: <20080601162150.GC5555@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806011955.06045.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 1 of June 2008, Pavel Machek wrote:
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

No, that won't work.  James uses Fedora.

Thanks,
Rafael
