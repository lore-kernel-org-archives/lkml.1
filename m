Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYCLXRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYCLXRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbYCLXRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:17:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:37784 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755980AbYCLXRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:17:32 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX186sB0ocZU6dN1IRaaTHALNSPRgLdkfwSo6umq2xX
	bOz5/exsfpQxUA
Date: Thu, 13 Mar 2008 00:17:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803130012470.14097@axis700.grange>
References: <200803110014.52985.rjw@sisk.pl>
 <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
 <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl>
 <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org>
 <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com>
 <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org>
 <20080312223431.GA24150@kroah.com> <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Linus Torvalds wrote:

> On Wed, 12 Mar 2008, Greg KH wrote:
> > 
> > What happend in .25-rc was that we now catch these kinds of problems
> > (watching for duplicate kobjects to be registered and such.)  So this
> > might have always been happening, but no warning was ever produced.
> 
> It's not the warning that worries me. It's the apparent oops (keyboard 
> leds blinking?) at shutdown/poweroff!

No, no oops, no blinking LEDs. The machine just stays there after syncing 
SCSI disks. I can still call sysrqs, and I've captured them with the 
serial console - see complete dumps here: 
http://bugzilla.kernel.org/attachment.cgi?id=15057

> Since there is at least a patch worth trying now, I'll hold off reverting 
> it and wait for Guennardi to test the patch, but the fact is, we shouldn't 
> have a known-broken kernel for several weeks, when there is a known fix 
> for it in reverting a single commit!

I'll test it in about 12 hours.

Thanks
Guennadi
---
Guennadi Liakhovetski
