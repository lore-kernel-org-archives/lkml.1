Return-Path: <linux-kernel-owner+w=401wt.eu-S1761744AbXKMU7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761744AbXKMU7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbXKMU7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:59:42 -0500
Received: from palrel13.hp.com ([156.153.255.238]:49580 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874AbXKMU7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:59:41 -0500
Date: Tue, 13 Nov 2007 13:59:39 -0700
From: Alex Chiang <achiang@hp.com>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Greg KH <greg@kroah.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, matthew@wil.cx, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113205939.GC22812@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Linas Vepstas <linas@austin.ibm.com>, Greg KH <greg@kroah.com>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	matthew@wil.cx, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113202424.GE8421@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113202424.GE8421@austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linas Vepstas <linas@austin.ibm.com>:
> On Tue, Nov 13, 2007 at 09:01:29AM -0800, Greg KH wrote:
> > 
> > Also, some companies already provide userspace tools to get
> > all of this information about the different slots in a system
> > and what is where, from userspace, no kernel changes are
> > needed.  So, why add all this extra complexity to the kernel
> > if it is not needed?
> 
> Second that motion.... I don't get it. What are the goals of
> this patch, really?  Just to get a "slot geographical location"
> from the kernel?  

Yes, plus some general cleanups in the PCI hotplug space (more
patches queued up, pending the results of this series ;)

But to use the word "just" kinda implies that this is a trivial
feature that no one really cares about, which I'm not really sure
I agree with. Slot geographical location is important for
managability folks, who want to know which slot out of 192 (on a
big HP ia64 system, e.g.) that their failing network card might
be sitting in.

And again, we (HP ia64) need to get this information from the
kernel.

> I'm balancing the intellectual appeal of having a kernel struct
> for representing physical objects, against the headache of
> reading (debugging, modifying) code that has yet another struct
> doing yet another thing.  So far, the dread of future headaches
> is winning.

Well, hopefully, the future is cleaner, rather than messier. ;)

> On pseries systems, I deal with something called the
> "partitionable endpoint", which I think probably usually
> corresponds to physical slots, but I don't really know.  
>
> So, naively, the physical slot concept doesn't really map to
> what I have to work with; it just adds one more appendix to it
> all, one more thing to get confused about.

Sorry, I'm a bit ignorant about pseries -- what kind of name does
your PCI hotplug driver give to those slots? What shows up in
/sys/bus/pci/slots/?

> To be clear: above remarks are for the PowerPC boxes. I have no
> clue about how things work on the IBM Intel-based boxes.  And
> Greg's original "get IBM to agree" remark is about the
> Intel-based boxes.

A split house. I have no idea how Proliants work either. :)

Thanks.

/ac

