Return-Path: <linux-kernel-owner+w=401wt.eu-S933910AbXFEVyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbXFEVyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933357AbXFEVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:53:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54801 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbXFEVx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:53:57 -0400
Date: Tue, 5 Jun 2007 14:46:13 -0700
From: Greg KH <greg@kroah.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: art@usfltd.com, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
Message-ID: <20070605214613.GB21578@kroah.com>
References: <20070517190058.w2oyxzf9wko4w8k8@67.106.77.50> <20070524175307.GA18940@kroah.com> <6bffcb0e0706050518l53628a55k7b91ce38e272289d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0706050518l53628a55k7b91ce38e272289d@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 02:18:26PM +0200, Michal Piotrowski wrote:
>  Hi,
> 
>  On 24/05/07, Greg KH <greg@kroah.com> wrote:
> > On Thu, May 17, 2007 at 07:00:58PM -0500, art@usfltd.com wrote:
> > >  greg
> > >
> > >  and part of /etc/udev/rules.d/60-libsane.rules
> > >
> > >  ...
> > >  ACTION!="add", GOTO="libsane_rules_end"
> > >  SUBSYSTEM!="usb_device", GOTO="libsane_rules_end"
> > >
> > >  # Hewlett-Packard ScanJet 4100C
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0101", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard Photosmart S20 (C5101A) | Hewlett-Packard Photosmart 
> > S20xi
> > >  (C7150A)
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0102", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 4200C | Hewlett-Packard ScanJet 4200Cxi |
> > >  Hewlett-Packard ScanJet 4200Cse
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0105", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 6200C | Hewlett-Packard ScanJet 6250C
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0201", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 3300c
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0205", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 4300c
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0305", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 5200C
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0401", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 3400c
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0405", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 2100C
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0505", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 6300C | Hewlett-Packard ScanJet 6350C |
> > >  Hewlett-Packard ScanJet 6390C
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0601", SYMLINK+="scanner-%k"
> > >  # Hewlett-Packard ScanJet 2200C
> > >  SYSFS{idVendor}=="03f0", SYSFS{idProduct}=="0605", SYMLINK+="scanner-%k"
> > >
> > >  ...
> > >  # Dell 1600n
> > >  SYSFS{idVendor}=="413c", SYSFS{idProduct}=="5250", SYMLINK+="scanner-%k"
> > >
> > >  LABEL="libsane_rules_end"
> >
> >
> > I don't see anything odd there at all.
> >
> > Can you run 'git bisect' to try to narrow down to the patch that caused
> > the problem?
> 
>  Any progress with this bug?

I haven't heard back from Art, and nothing looks wrong in the rules file
above...

thanks,

greg k-h
