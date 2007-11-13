Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbXKMWQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbXKMWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760233AbXKMWQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:16:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:37750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbXKMWQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:16:45 -0500
Date: Tue, 13 Nov 2007 14:16:23 -0800
From: Greg KH <gregkh@suse.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <greg@kroah.com>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113221623.GA5965@suse.de>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113203645.GB22812@ldl.fc.hp.com> <20071113213049.GA4194@kroah.com> <200711131501.01320.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711131501.01320.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 03:01:01PM -0700, Bjorn Helgaas wrote:
> On Tuesday 13 November 2007 02:30:49 pm Greg KH wrote:
> > On Tue, Nov 13, 2007 at 01:36:45PM -0700, Alex Chiang wrote:
> > > * Greg KH <greg@kroah.com>:
> > > > IBM sells a program that does this for server rooms.  It's
> > > > probably part of some Tivoli package somewhere, sorry I don't
> > > > remember the name.  I did see it working many years ago and it
> > > > required no kernel changes at all to work properly.
> 
> Do you know how this Tivoli package works or where it gets the
> information?

I was told it was just reading the ACPI tables from userspace.  As I saw
it running on a machine without a modified kernel, I had no reason to
doubt this, but it might be doing something else for all I know.

What I do know is that it somehow does work without any kernel changes
needed, and is in use today by very large data centers without any
problems.

> > > Like I said in an earlier email, HP ia64 systems will require a
> > > kernel change to get this information. Whether it comes via a
> > > generic ACPI access layer like dev_acpi, or something like this
> > > patch series, the kernel will still get touched.
> > 
> > And like I said, I'm pretty sure you don't need to touch the kernel
> > today as there are people doing this just fine from userspace without
> > any kernel changes needed :)
> 
> I think you are assuming userspace can just dump the raw ACPI tables
> and extract this information from them.  But I don't think that's
> possible because _SUN is a method that can contain arbitrary AML.
> That AML has to be *executed*, and you can't do that safely in
> userspace.

Yes, I was assuming that based on the above running code, if this is
somehow impossible to do from userspace, I don't know what the code is
doing.

thanks,

greg k-h
