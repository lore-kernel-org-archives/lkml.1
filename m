Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYCLXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYCLXhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYCLXh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:37:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYCLXh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:37:26 -0400
Date: Wed, 12 Mar 2008 16:37:09 -0700
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
	Reported regressions from 2.6.24)
Message-ID: <20080312233709.GA25530@kroah.com>
References: <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com> <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org> <20080312223431.GA24150@kroah.com> <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org> <20080312231601.GB24820@kroah.com> <Pine.LNX.4.64.0803130031190.14097@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803130031190.14097@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 12:32:48AM +0100, Guennadi Liakhovetski wrote:
> On Wed, 12 Mar 2008, Greg KH wrote:
> 
> > It oopses at shutdown?  I thought this was originally reported as a
> > "will not power off" which for a while was attributed to the cpufreq fix
> > that went into -rc2 or -rc3.
> 
> As I already replied to Linus, no, it doesn't.
> 
> > It would be interesting to see if reverting the pci_bus patch did
> > anything about the fact that we register the root PCI bus through two
> > different methods.
> 
> You mean this: http://marc.info/?l=linux-kernel&m=120483340622706&w=2

Yes, the warnings go away as there is no more struct device to register,
but the big "PCI:" messages from the syslog at startup with the patch
reverted is what I am curious about.

I'll test more in a few hours, have to go herd the kids off to piano
lessons...

thanks,

greg k-h
