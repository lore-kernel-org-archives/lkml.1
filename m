Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbYHEQ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbYHEQ5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbYHEQ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:56:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875AbYHEQ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:56:51 -0400
Date: Tue, 5 Aug 2008 09:53:45 -0700
From: Greg KH <greg@kroah.com>
To: Russ Anderson <rja@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number
	on SGI UV
Message-ID: <20080805165345.GA9396@kroah.com>
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com> <20080804221951.GA252105@sgi.com> <4897A5FE.9070703@zytor.com> <20080805035450.GA11810@kroah.com> <20080805163229.GA14870@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805163229.GA14870@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:32:30AM -0500, Russ Anderson wrote:
> On Mon, Aug 04, 2008 at 08:54:50PM -0700, Greg KH wrote:
> > On Mon, Aug 04, 2008 at 05:59:42PM -0700, H. Peter Anvin wrote:
> > > Russ Anderson wrote:
> > >>> This really seems more that it should belong in sysfs -- 
> > >>> /sys/class/firmware presumably.
> > >> /proc/sgi_uv already exists, similar to /proc/sgi_sn on Itanium systems.
> > >> Would it be /sys/class/firmware?  Reading Documentation/sysfs-rules.txt
> > >> seems to indicate somewhere under /sys/devices, such as 
> > >> /sys/devices/system/,
> > >> but I may be wrong.
> > >
> > > /sys/class/firmware is usually where firmware-related things end up, but 
> > > gregkh is the authority on sysfs organization.
> > 
> > /sys/class/firmware has a few users, but perhaps you are thinking of
> > /sys/firmware instead?  That's probably the better place for something
> > that is not using the firmware class itself.
> 
> Hi Greg,
> 
> If /sys/firmware is the right place, that is where I will put it.
> 
> Are the rules for /sys/firmware documented?  Documentation/sysfs-rules.txt
> does not mention /sys/firmware.  It seems to indicate that /sys/class
> should only contain symlinks:

Yes, using /sys/class is when using a 'struct device', is that what you
are using, or are you stuck with "raw" kobjects?

What exactly are you wanting to place in sysfs?  That will make it
easier to determine where to put it :)

Do you have a patch showing what you are proposing?

thanks,

greg k-h
