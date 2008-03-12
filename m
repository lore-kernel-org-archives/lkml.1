Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYCLXrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYCLXrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYCLXrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:47:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:34716 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751572AbYCLXrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:47:12 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19+FqgV9a9+3tQqxmimNGOhWkAlX//LDjp+U/rZGX
	iiTRO9wfBbcPNS
Date: Thu, 13 Mar 2008 00:47:13 +0100 (CET)
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
In-Reply-To: <alpine.LFD.1.00.0803121636030.3557@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803130045570.14097@axis700.grange>
References: <200803110014.52985.rjw@sisk.pl>
 <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
 <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl>
 <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org>
 <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com>
 <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org>
 <20080312223431.GA24150@kroah.com> <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803130012470.14097@axis700.grange>
 <alpine.LFD.1.00.0803121636030.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Linus Torvalds wrote:

> On Thu, 13 Mar 2008, Guennadi Liakhovetski wrote:
> > 
> > No, no oops, no blinking LEDs.
> 
> Oh, the original report says:
> 
>   "Problem Description: Power off / reboot blink keyboard LEDs and leave 
>    the system at .."
> 
> which is why I thought it might be a hidden oops.
> 
> But that must have been some unrelated and misleading red herring.

Ah, ok, I see now. No, no herring here. The LEDs just blink _once_ as they 
always do before shutdown (on this machine?). But the machine stays on.

Thanks
Guennadi
---
Guennadi Liakhovetski
