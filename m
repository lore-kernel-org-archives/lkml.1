Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbXIRUm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbXIRUm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbXIRUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:42:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371AbXIRUmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:42:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325
Date: Tue, 18 Sep 2007 22:54:54 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709182221.53513.rjw@sisk.pl>
In-Reply-To: <200709182221.53513.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709182254.55409.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 18 September 2007 22:21, Rafael J. Wysocki wrote:
> On Tuesday, 18 September 2007 10:18, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> > 
> > 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> > 
> > It took me over two solid days to get this lot compiling and booting on a few
> > boxes.  This required around ninety fixup patches and patch droppings.  There
> > are several bugs in here which I know of (details below) and presumably many
> > more which I don't know of.  I have to say that this just isn't working any
> > more.
> > 
> > - The Vaio hangs when quitting X due to x86_64-mm-cpa-clflush.patch, but
> >   I didn't drop that patch because the iommu patch series depends on it.
> > 
> > - The Vaio also hangs during resume-from-RAM, due to git-acpi.patch
> > 
> > - And it hangs during suspend-to-RAM, due to git-acpi.patch

Sorry, I was wrong.

> On my HP nx6325 it only boots with "noacpitimer nohpet" on the command line,
> but then it works.

It _sometimes_ boots with "noacpitimer nohpet" and that's if I press the power
button for a couple of times during boot (before any messages appear on the
console).

> Suspend-to-RAM and hibernation work too. :-) 

No, they don't (I must have booted -rc6 instead of it by mistake, sigh).

> Since 2.6.23-rc4-mm1 only booted with nohpet because of
> 
> x86_64-convert-to-clockevents.patch
> 
> I guess that the boot problems with this one result from the same patch.

Not sure any more ...

I'll try to compile it with NO_HZ and HIGH_RES_TIMERS unset.

Greetings,
Rafael
