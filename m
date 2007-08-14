Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbXHNP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbXHNP0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760324AbXHNPZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:25:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:52242 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758637AbXHNPZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:25:25 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: Documentation - How to debug ACPI Problems
Date: Tue, 14 Aug 2007 11:25:08 -0400
User-Agent: KMail/1.9.5
Cc: "Brown, Len" <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
       Alexey Starikovskiy <aystarik@gmail.com>
References: <1181140008.28514.259.camel@queen.suse.de> <200706180012.05665.lenb@kernel.org> <1182165527.28514.589.camel@queen.suse.de>
In-Reply-To: <1182165527.28514.589.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708141125.09000.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007 07:18, Thomas Renninger wrote:
> On Mon, 2007-06-18 at 00:12 -0400, Len Brown wrote:
> > > +2. Overriding DSDT
> > > +------------------
> > > +
> > > +The DSDT (there is a patch also for SSDTs) can be overridden by the user.
> > > +The tables get copied to RAM when booting and the kernel can override them with
> > > +alternative tables at early boot time.
> > > +
> > > +Historically people used to override their DSDT to workaround BIOS or even
> > > +kernel bugs. This is a bad idea, the override functionality is for short
> > > +term workarounds and mainly for debugging! Please always report such bugs to
> > > +bugzilla.kernel.org or post to linux-acpi@vger.kernel.org if unsure.
> > > +
> > > +There are two possibilities to override the DSDT:
> > > +
> > > +  - via CONFIG_ACPI_CUSTOM_DSDT (and _FILE) compile option(s)
> > > +  - via adding a customized DSDT into initramfs
> > > +
> > > +The second approach does not need kernel recompilation and some distributions
> > > +provide the patch, which is not included in mainline, in their kernels.
> > > +
> > > +The patch and more information can be found here (many thanks to Markus
> > > +Gaugusch and Eric Piel):
> > > +http://gaugusch.at/kernel.shtml
> > > +
> > 
> > how to override the DSDT by re-compiling the upstream kernel
> > is already documented here:
> > 
> > http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/README.ACPI
> Ah yes, a link to this one is quite convenient...
> 
> > It seems inconsistent to refer to the initrd patch from the in-tree Documentation,
> > since that patch will always be out-of-tree.
> It is inconsistent to point to a useful debug patch outside the kernel?
> 
> > I would think that the in-tree Documentation would refer to specifics relating
> > to the kernel that is actually checked into the tree with the Documentation.
> > This assumption can probably clear up some of the wording relating to the
> > debug flags -- we don't have to describe the old ones -- if somebody is
> > reading this documentation, they already have the new ones:-)
> rip out mentioning /proc/acpi/debug_{level,layer}?
> Ok.
> 
> > Asside from those specific things that describe the kernel in the tree,
> > I'm thinking that acpi.sourceforge.net documentation would be a better
> > place for a general HOWTO on debugging ACPI issues in general.
> Looking at:
> http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/README.ACPI,
> maybe we could just add that one instead to Documentation/acpi/*?
> If, splitting would IMO be easier to read, e.g. something like:
>   - report_acpi_kernel_bugs.txt
>   - sending_ACPI_patches.txt
>   - debugging_acpi_kernel_errors.txt

Okay, good suggestion, I'll do it.

thanks,
-Len
