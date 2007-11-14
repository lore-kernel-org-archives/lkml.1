Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbXKNTxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbXKNTxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbXKNTxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:53:15 -0500
Received: from palrel11.hp.com ([156.153.255.246]:43648 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbXKNTxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:53:13 -0500
Date: Wed, 14 Nov 2007 12:53:11 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <greg@kroah.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>, gregkh@suse.de,
       lenb@kernel.org, matthew@wil.cx, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114195311.GG25002@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <greg@kroah.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
	linux-pci@atrey.karlin.mff.cuni.cz,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	gregkh@suse.de, lenb@kernel.org, matthew@wil.cx, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113202632.GA3227@kroah.com> <20071113145936.7e1c58fb.kristen.c.accardi@intel.com> <200711141037.09228.bjorn.helgaas@hp.com> <20071114175317.GB14994@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114175317.GB14994@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

* Greg KH <greg@kroah.com>:
> On Wed, Nov 14, 2007 at 10:37:08AM -0700, Bjorn Helgaas wrote:
> > 
> > So I agree that the firmware kit has a clever hack that works
> > on much existing x86 firmware, and it sounds like Tivoli
> > might even rely on it.  But I don't feel good about it, and
> > it could easily break when some BIOS writer needs to make
> > _SUN slightly more complicated.
> 
> Do you know of such BIOSes out there that do this?  Will the
> above scheme not work for the ia64 boxes that you know of that
> are out in the world today?

Matthew and Bjorn have already been hinting at this, but I'd like
to voice my concern as well.

Even if no one is implementing _SUN as a complicated AML control
method today, that is no guarantee that prevents future firmware
vendors from doing so. The spec allows it, so in my opinion,
pointing to existing implementations and claiming that it all
just works is somewhat unfair (and scary).

If/when the first vendor implements an AML version of _SUN, the
firmware kit will break, and Tivoli will have to react.

I was initially intrigued with you and Kristen pointed out this
tool, but after thinking about it some more, I am not convinced
it is a viable alternative, due to the unknown nature of future
firmware implementations.

Thanks.

/ac

