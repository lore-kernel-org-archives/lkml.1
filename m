Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYCXU3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYCXU3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYCXU30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:29:26 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:42896 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYCXU3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:29:25 -0400
Date: Mon, 24 Mar 2008 14:29:24 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, Greg KH <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 9/16] PCI slot: Remove unused slot member from pci_dev
	(Not for mainline!)
Message-ID: <20080324202924.GC11575@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	warthog19@eaglescrag.net, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E33693.7080102@jp.fujitsu.com> <20080321193009.GI424@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321193009.GI424@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi willy,

* Matthew Wilcox <matthew@wil.cx>:
> On Fri, Mar 21, 2008 at 01:16:19PM +0900, Kenji Kaneshige wrote:
> > The 'slot' member in struct pci_dev is not used. Remove this unused
> > member.
> 
> It *ought* to be used.  If it isn't yet, I guess that part of my patch
> has been dropped, and it should be re-added.
 
I checked through your original patch set:

	http://www.parisc-linux.org/~willy/pci-slot-2b/

And although I see a bunch of uses of pci_bus->slot, I don't see
any uses of pci_dev->slot.

Wanna enlighten me? :)

/ac

