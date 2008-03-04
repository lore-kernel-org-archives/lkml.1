Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYCDFx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYCDFx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYCDFxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:53:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:42340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYCDFxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:53:45 -0500
Date: Mon, 3 Mar 2008 21:49:27 -0800
From: Greg KH <gregkh@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080304054927.GA15566@suse.de>
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002938.GE21420@ldl.fc.hp.com> <20080301052542.GD19353@suse.de> <20080301144307.GD24386@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301144307.GD24386@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 07:43:07AM -0700, Matthew Wilcox wrote:
> On Fri, Feb 29, 2008 at 09:25:42PM -0800, Greg KH wrote:
> > What is the guarantee that the names of these slots are correct and do
> > not happen to be the same as the hotpluggable ones?
> 
> That would be a bug -- and yes, bugs happen, and we have to deal with
> them.

My main concern is that BIOS vendors will not fix these bugs, as no
other OS cares/does this kind of thing today.  The ammount of bad
information out there might be quite large, and I think this was
confirmed by some initial testing of IBM systems, right?

> > Why show this information on machines that can not do anything with
> > these slots at all?  Will that not just confuse people?
> 
> Only for people who think that /sys/bus/pci/slots/ is for hotpluggable
> slots only.  There is plenty of useful information available for slots
> that aren't hotpluggable (eg bus address, speed, width, error status).

Can the userspace tools that are using the existing directories thinking
that only hotplug slots are there, handle "non-hotplug" slots showing up
in this location?

thanks,

greg k-h
