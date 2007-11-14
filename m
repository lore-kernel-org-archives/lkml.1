Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbXKNTgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbXKNTgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbXKNTgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:36:08 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21319 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbXKNTgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:36:07 -0500
Date: Wed, 14 Nov 2007 12:36:05 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       achiang@hp.com, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: [PATCH 0/5, v2] Physical PCI slot objects
Message-ID: <20071114193605.GA25002@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@hp.com>:
> 
> Actually, I just reworked my patch this morning, and believe that
> I have a much cleaner implementation now that should fix a lot of
> the errors you saw.

Patch 1/5 - reworked to fix stupid compile bug
Patch 2/5 - incorporate Eike, Linas, and Willy's comments
Patch 3/5 - no change
Patch 4/5 - was acpi-pci-slot-driver patch, now modifies
	    pci_add_hotplug(). I changed the ordering on this so
	    the tree doesn't break at this point in the series
Patch 5/5 - now is acpi-pci-slot-driver patch, cleaned up
	    implementation so our slot detection is a little
	    better

Thanks.

/ac

