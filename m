Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbYH3Fiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbYH3Fiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYH3Fiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:38:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:54928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYH3Fip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:38:45 -0400
Date: Fri, 29 Aug 2008 22:37:55 -0700
From: Greg KH <gregkh@suse.de>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: refcount leak in pci_get_device()?
Message-ID: <20080830053755.GA16219@suse.de>
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de> <20080821221438.GC20014@ldl.fc.hp.com> <7A25B56E4BE99C4283EB931CD1A40E110177E488@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110177E488@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 12:23:20PM +0800, Zhao, Yu wrote:
> And the pci_get_dev_by_id() is not safe again the PCI device removal.
> It might fire a warning in bus_find_device() when reference count of
> the knode_bus is decreased to 0 by pci_remove_bus().

Is this something new?  Hasn't this always been that way?  Why would you
be wanting to call this function anyway?

thanks,

greg k-h
