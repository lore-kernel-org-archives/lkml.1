Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbXKMUDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbXKMUDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbXKMUDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:03:34 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42095 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178AbXKMUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:03:33 -0500
Date: Tue, 13 Nov 2007 13:03:31 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Alex Chiang <achiang@hp.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/5, RFC] Introduce pci_slot
Message-ID: <20071113200331.GJ17785@parisc-linux.org>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113001447.GD13341@ldl.fc.hp.com> <20071113195646.GD8421@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113195646.GD8421@austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 01:56:46PM -0600, Linas Vepstas wrote:
> On Mon, Nov 12, 2007 at 05:14:47PM -0700, Alex Chiang wrote:
> > +/* pci_slot represents a physical slot */
> > +struct pci_slot {
> > +	struct pci_bus *bus;		/* The bus this slot is on */
> > +	struct pci_slot *next;		/* Next slot on this bus */
> > +	struct hotplug_slot *hotplug;	/* Hotplug info (migrate over time) */
> 
> How much migration do you expect?  Some of it? All of it? If the
> answer is "all of it", wouldn't it just be easier to rename 
> struct hotplug_slot, and go from there?

Only the bits that make sense for non-hotpluggable slots.

I tried your suggestion first.  It wasn't much fun.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
