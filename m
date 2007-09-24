Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbXIXNFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbXIXNFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbXIXNFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:05:04 -0400
Received: from www.osadl.org ([213.239.205.134]:41328 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751117AbXIXNFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:05:03 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200709241457.40669.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <200709232252.41975.rjw@sisk.pl> <1190621243.4035.171.camel@chaos>
	 <200709241457.40669.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 15:05:01 +0200
Message-Id: <1190639101.4035.185.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 14:57 +0200, Rafael J. Wysocki wrote:
> > > http://tglx.de/projects/hrtimers/2.6.23-rc4/patch-2.6.23-rc4-hrt1.patches.tar.bz2
> > > 
> > > applied.  I also have the 2.6.23-rc6-mm1 dmesg output ready, but there's some
> > > -mm-specific noise in it.  Please let me know if you want it, though.
> > 
> > Hmm:
> > 
> > > Command line: root=/dev/sda3 vga=792 resume=/dev/sda1 noacpitimer apic=verbose 2
> > --------------------------------------------------------^^^^^^^^^^^
> > 
> > noacpitimer is not a valid commandline option.
> > 
> > I asked for: 
> > >> > > noapictimer
> 
> I'm blind, sorry.
> 
> > So I really wonder, why noacpitimer on the kernel command line makes any
> > difference. I'm confused.
> 
> \metoo
> 
> Well, it was probably read as "noacpi". :-)

Hmm, ACPI is in the log all over the place.

> Fortunately, noapictimer helps as well, dmesg attached (I have the one
> from 2.6.23-rc6-mm1 ready, too).

Ok, at which point is the box stopping, when you omit noa* ? Is
earlyprintk giving you any useful info ?

	tglx




