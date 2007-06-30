Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbXF3UX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbXF3UX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 16:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXF3UXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 16:23:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35088 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbXF3UXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 16:23:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Sat, 30 Jun 2007 22:30:18 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200706301215.20334.rjw@sisk.pl> <20070630101112.GA10444@elf.ucw.cz>
In-Reply-To: <20070630101112.GA10444@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706302230.19040.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 30 June 2007 12:11, Pavel Machek wrote:
> Hi!
> 
> > > > Sorry, but I can't resist the opportunity to say "Send a patch!" :)
> > > > 
> > > > Seriously, though, I'd prefer not to. If we rename that acpi video flags 
> > > > variable (I assume this is what you're thinking of), we only create cause for 
> > > > confusion. A variable should for debugging or for controlling quirks, not for 
> > > > both at the same time.
> > > 
> > > Cause for confusion? We are currently using 2 bits of that variable,
> > > and we want to add one more bit. I seriously doubt that can confuse
> > > anyone.
> > 
> > Well, indeed it would be more elegant to rename the existing flags variable
> > and use another bit out of it, but I personally don't think it's _that_
> > important.  At least, I don't think we should block the patch
> > because of that.
> 
> It is not _that_ important.
> 
> > BTW, has anyone confirmed that it works on i386?
> 
> If you have patch somewhere nearby, I can test it on i386 and make it
> use just one flags variable.

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc6/patches/28-Optional-Beeping-During-Resume-From-RAM.patch

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
