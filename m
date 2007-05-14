Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbXENGy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbXENGy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXENGyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:54:49 -0400
Received: from www.osadl.org ([213.239.205.134]:40077 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754298AbXENGys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:54:48 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070513234243.2b17bc2a.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	 <20070511132846.5ebf4437.akpm@linux-foundation.org>
	 <200705112302.47726.rjw@sisk.pl> <200705112309.15996.rjw@sisk.pl>
	 <20070511235607.83ad0eb5.akpm@linux-foundation.org>
	 <1178959563.22481.126.camel@localhost.localdomain>
	 <20070512020056.a24cf472.akpm@linux-foundation.org>
	 <1179072770.22481.265.camel@localhost.localdomain>
	 <20070513234243.2b17bc2a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 08:58:00 +0200
Message-Id: <1179125881.22481.299.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 23:42 -0700, Andrew Morton wrote:
> On Sun, 13 May 2007 18:12:50 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Sat, 2007-05-12 at 02:00 -0700, Andrew Morton wrote:
> > > Still hangs in the same fashion, sorry.
> > > 
> > > It's peculiar that the hang happens when acpi_evaluate_object() hits its
> > > return statement.  Any theories there?
> > 
> > I assume you have a printk right before the return and one after the
> > call to acpi_evaluate_object().
> > 
> > Can you dump the stack at the point before the return, so we can see if
> > the stack is corrupt there ? A WARN_ON(1) should do the trick.
> > 
> 
> It all looks clean.  I spose I should do a hex dump and a byte-by-byte
> walkthough, but time is short...

I could backport the highres/dyntick stuff to 2.6.20, so we have the
other changes out of the picture.

	tglx


