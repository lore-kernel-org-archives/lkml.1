Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbXK2BKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbXK2BKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760527AbXK2BJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:09:51 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53023 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXK2BJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:09:50 -0500
Date: Wed, 28 Nov 2007 17:09:35 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Alex Chiang <achiang@hp.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071129010935.GB6199@us.ibm.com>
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com> <20071127030454.GC23277@us.ibm.com> <20071127111136.77cb61fc@appleyard> <20071128213147.GA6199@us.ibm.com> <20071128160238.3c8685e5@orpington>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128160238.3c8685e5@orpington>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 04:02:38PM -0800, Kristen Carlson Accardi wrote:
> On Wed, 28 Nov 2007 13:31:47 -0800
> Gary Hade <garyhade@us.ibm.com> wrote:
> 
> > FYI, the node contains 2 hotpluggable PCIe slots and 5
> > non-hotpluggable PCIe slots but 'pci_slot' only exposed
> > the 2 hotpluggable slots.  This does not appear to be due
> > to a 'pci_slot' driver problem since I looked at the DSDT
> > and SSDT and found that there are currently no _SUN methods
> > for the non-hotpluggable slots.
> 
> Thanks for testing Gary.  I would think this situation would be the
> common case, since I doubt most firmware writers would bother to
> implement _SUN for non-hotpluggable slots -- at least on other DSDT
> I've seen this has been the case as well.  

Yea, I was also not surprised although features such as
Alex working on may provide some motivation to change that.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

