Return-Path: <linux-kernel-owner+w=401wt.eu-S1030462AbXBOS1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030462AbXBOS1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030465AbXBOS1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:27:33 -0500
Received: from tim.rpsys.net ([194.106.48.114]:40274 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030464AbXBOS1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:27:32 -0500
Subject: Re: 2.6.20-mm1
From: Richard Purdie <rpurdie@rpsys.net>
To: Marcin Juszkiewicz <openembedded@hrw.one.pl>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200702151900.18270.openembedded@hrw.one.pl>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	 <200702151733.l1FHXatF025688@turing-police.cc.vt.edu>
	 <200702151900.18270.openembedded@hrw.one.pl>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Feb 2007 18:27:09 +0000
Message-Id: <1171564029.5839.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 19:00 +0100, Marcin Juszkiewicz wrote:
> Dnia czwartek, 15 lutego 2007, Valdis.Kletnieks@vt.edu napisał:
> > On Thu, 15 Feb 2007 05:14:08 PST, Andrew Morton said:
> 
> > git-backlight.patch contains this:
> >
> > +config BACKLIGHT_PROGEAR
> > +       tristate "Frontpath ProGear Backlight Driver"
> > +       depends on BACKLIGHT_CLASS_DEVICE && PCI && X86
> > +       default y
> > +       help
> > +         If you have a Frontpath ProGear say Y to enable the
> > +         backlight driver.
> >
> > Should that be a default N or M, given that relatively few people have
> > that device?
> 
> "default n" as this is rather rare used today device. Should I send 
> a patch or can it be changed without it?

Its probably easiest if I just fix that.

Cheers,

Richard

