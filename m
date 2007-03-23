Return-Path: <linux-kernel-owner+w=401wt.eu-S2992621AbXCWXI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992621AbXCWXI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992627AbXCWXI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:08:57 -0400
Received: from mail.kroah.org ([69.55.234.183]:48940 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992621AbXCWXIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:08:55 -0400
Date: Fri, 23 Mar 2007 15:49:17 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>, bk@suse.de
Cc: Francis Moreau <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI probing failure in 2.6.21-rc3
Message-ID: <20070323224917.GC23534@kroah.com>
References: <38b2ab8a0703140147s24bfc656o1bbff4abc405d61d@mail.gmail.com> <20070315110647.710bff5f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315110647.710bff5f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 11:06:47AM -0800, Andrew Morton wrote:
> > On Wed, 14 Mar 2007 09:47:42 +0100 "Francis Moreau" <francis.moro@gmail.com> wrote:
> > I already posted this issue but it was on a 2.6.19.7 kernel
> > (2.6.19-1.2911.6.5.fc6 to be accurate). So it doesn't seem to be a
> > regression.
> > 
> > During boot the console shows up this:
> > 
> > [...]
> > PCI: Probing PCI hardware (bus 00)
> > PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
> > PCI quirk: region 1180-11bf claimed by ICH6 GPIO
> > 0000:00:1f.2: trying to change BAR0 from 0000 to 01F0
> > 0000:00:1f.2: trying to change BAR1 from 0000 to 03F4
> > 0000:00:1f.2: trying to change BAR2 from 0000 to 0170
> > 0000:00:1f.2: trying to change BAR3 from 0000 to 0374
> > Boot video device is 0000:01:00.0
> > PCI: Transparent bridge - 0000:00:1e.0
> > PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#07)
> > (try 'pci=assign-busses')
> > Please report the result to linux-kernel to fix this permanently
> > [...]
> > 
> > I haven't time to test 'pci=assign-busses' option, I'll do it later,
> > but I wanted to report this ASAP.
> 
> Greg, could we please either 
> 
> a) start doing something about these reports or
> b) publish sufficient info to permit others to do something about these
>    reports or 
> c) remove the printk?

Ugh, I'm getting really tired of it too.  Bernhard, any plans on
addressing these constant reports?  You sent me this patch and then seem
to have disappered when dealing with the fallout of the different
messages :(

Should I just revert your original patch all-together?

thanks,

greg k-h
