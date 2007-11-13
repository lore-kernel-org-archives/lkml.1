Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXKMUU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXKMUU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762088AbXKMUUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:20:25 -0500
Received: from ns2.suse.de ([195.135.220.15]:56181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761690AbXKMUUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:20:22 -0500
Date: Tue, 13 Nov 2007 12:19:54 -0800
From: Greg KH <gregkh@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Alex Chiang <achiang@hp.com>,
       kristen.c.accardi@intel.com, lenb@kernel.org, richard.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113201954.GA26547@suse.de>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113201102.GK17785@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113201102.GK17785@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:11:02PM -0700, Matthew Wilcox wrote:
> On Tue, Nov 13, 2007 at 10:51:22AM -0800, Greg KH wrote:
> > Ok, again, I want to see the IBM people sign off on this, after testing
> > on all of their machines, before I'll consider this, as I know the IBM
> > acpi tables are "odd".
> 
> That seems a little higher standard than patches are normally held to.
> How about the patches get sent to the appropriate people at IBM (who are
> they?) and if we haven't heard a NAK from them after a month, then they
> get applied?

When you are touching code that I know is going to have problems on a
whole range of different manufacturer's machines, do you expect me to
just ignore that and let you add a feature that is going to be
incorrect?

> > Also, how about Dell machines?  I know they are probably not expecting
> > this information to show up and who knows if the numbering of their
> > slots match up with their physical diagrams (I say this based on all of
> > the eth0/eth1 "issues" with Dell machines over the years...)
> 
> I'm pretty sure that Windows uses the _SUN information, so I think this
> is going to be well-tested.

Again, based on the past history with such things as mis-labeled
ethernet ports, I have doubts.  I can hope, but I need proof based on
the major problems we have had in the past.

It is better to not show information to users at all, then to give them
information that is incorrect, don't you think?

> > IBM sells a program that does this for server rooms.  It's probably part
> > of some Tivoli package somewhere, sorry I don't remember the name.  I
> > did see it working many years ago and it required no kernel changes at
> > all to work properly.
> 
> Well, yes, it doesn't take kernel effort if you're willing to build
> proprietary knowledge into a userspace program.  This seems similar
> to the argument that filesystems don't need to be in the kernel since
> they can be implemented in user space.  They work better in the kernel,
> just like this does.

Don't mix up things like filesystems and exposing pci slots.  That is
just foolish...

thanks,

greg k-h
