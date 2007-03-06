Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXCFJKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXCFJKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXCFJKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:10:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41079 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152AbXCFJKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:10:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Kconfig: Update swsusp description
Date: Tue, 6 Mar 2007 10:13:13 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703041514.44680.rjw@sisk.pl> <20070306083224.GE2040@elf.ucw.cz>
In-Reply-To: <20070306083224.GE2040@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061013.13585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 6 March 2007 09:32, Pavel Machek wrote:
> Hi!
> 
> > Index: linux-2.6.21-rc2/kernel/power/Kconfig
> > ===================================================================
> > --- linux-2.6.21-rc2.orig/kernel/power/Kconfig	2007-02-28 23:54:45.000000000 +0100
> > +++ linux-2.6.21-rc2/kernel/power/Kconfig	2007-03-04 11:50:48.000000000 +0100
> > @@ -81,30 +81,35 @@ config SOFTWARE_SUSPEND
> >  	bool "Software Suspend"
> >  	depends on PM && SWAP && ((X86 && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
> >  	---help---
> > +	  Enable the suspend to disk (STD) functionality.
> >  
> > +	  You can suspend your machine with 'echo disk > /sys/power/state'.
> > +	  Alternatively, you can use the additional userland tools available
> > +	  from <http://suspend.sf.net>.
> > +
> > +	  In principle it does not require ACPI or APM, although for example
> > +	  ACPI will be used if available.
> > +
> > +	  It creates an image which is saved in your active swap. Upon the next
> >  	  boot, pass the 'resume=/dev/swappartition' argument to the kernel to
> 
> Actually, these days resume=... on kernel command line needs to be
> there for suspend, too, IIRC.

I didn't change this line, so?
 
> > +	  Right now you may boot without resuming and resume later but in the
> > +	  meantime you cannot use the swap partition(s)/file(s) involved in
> > +	  suspending.  Also in this case you must not use the
> 
> I'd prefer not to encourage this use. It has too many traps ready for
> people.

But IMHO there should be a warning that if you boot without resuming, make sure
you'll not resume after the next reboot or bad things will happen.

Greetings,
Rafael
