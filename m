Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbYCLUcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbYCLUcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYCLUcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:32:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54728 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYCLUcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:32:32 -0400
Date: Wed, 12 Mar 2008 13:32:05 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Message-ID: <20080312203205.GB17187@kroah.com>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 01:01:15PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 11 Mar 2008, Rafael J. Wysocki wrote:
> 
> > 
> > In http://bugzilla.kernel.org/show_bug.cgi?id=10123 Guennadi says that
> > reverting
> > 
> > commit fd7d1ced29e5beb88c9068801da7a362606d8273
> > Author: Greg Kroah-Hartman <gregkh@suse.de>
> > Date:   Tue May 22 22:47:54 2007 -0400
> > 
> >     PCI: make pci_bus a struct device
> > 
> > fixes the problem for him (this seems to be yet another reboot/poweroff IOW).
> 
> Ahh, I thought this was done already, but nope, my PCI pull from Greg 
> didn't contain the revert.
> 
> Greg? I know you must be aware of the problem, because you replied to the 
> email at some point. Wazzup?

I'm still trying to figure out why his is the only machine having
problems with this.  I think it's an acpi "we walk the list of pci
devices twice" type thing, but don't know yet.

I'm still working on it...

thanks,

greg k-h
