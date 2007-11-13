Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbXKMULT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbXKMULT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbXKMULI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:11:08 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33149 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbXKMULF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:11:05 -0500
Date: Tue, 13 Nov 2007 13:11:02 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Alex Chiang <achiang@hp.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113201102.GK17785@parisc-linux.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113185122.GA22536@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 10:51:22AM -0800, Greg KH wrote:
> Ok, again, I want to see the IBM people sign off on this, after testing
> on all of their machines, before I'll consider this, as I know the IBM
> acpi tables are "odd".

That seems a little higher standard than patches are normally held to.
How about the patches get sent to the appropriate people at IBM (who are
they?) and if we haven't heard a NAK from them after a month, then they
get applied?

> Also, how about Dell machines?  I know they are probably not expecting
> this information to show up and who knows if the numbering of their
> slots match up with their physical diagrams (I say this based on all of
> the eth0/eth1 "issues" with Dell machines over the years...)

I'm pretty sure that Windows uses the _SUN information, so I think this
is going to be well-tested.

> IBM sells a program that does this for server rooms.  It's probably part
> of some Tivoli package somewhere, sorry I don't remember the name.  I
> did see it working many years ago and it required no kernel changes at
> all to work properly.

Well, yes, it doesn't take kernel effort if you're willing to build
proprietary knowledge into a userspace program.  This seems similar
to the argument that filesystems don't need to be in the kernel since
they can be implemented in user space.  They work better in the kernel,
just like this does.

By the way, the end result of this should be a pci-hotplug system that has
much less code in the drivers, more uniformity between the presentation
to userspace, more functionality and is easier to understand.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
