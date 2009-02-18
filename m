Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZBRPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZBRPf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZBRPfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:35:14 -0500
Received: from kroah.org ([198.145.64.141]:37495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752203AbZBRPfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:35:13 -0500
Date: Wed, 18 Feb 2009 07:13:56 -0800
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 6/7] PCI: document SR-IOV sysfs entries
Message-ID: <20090218151356.GB26373@kroah.com>
References: <1234790920-1810-1-git-send-email-yu.zhao@intel.com> <1234790920-1810-7-git-send-email-yu.zhao@intel.com> <20090217125021.GA2403@yzhao-otc.sh.intel.com> <20090218034910.GA10990@kroah.com> <20090217144303.GA2452@yzhao-otc.sh.intel.com> <20090218062116.GA20081@kroah.com> <20090217170135.GA2520@yzhao-otc.sh.intel.com> <20090218071916.GA15114@kroah.com> <20090217192155.GA2612@yzhao-otc.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217192155.GA2612@yzhao-otc.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 03:21:55AM +0800, Yu Zhao wrote:
> > Care to describe what you are trying to do first?
> 
> I'd like to link child PCI devices to their parent PCI device's
> subdirectory.  These child PCI devices are PCI functions that are on
> the same level as their parent in the PCI hierarchy, so current PCI code
> won't create symbol links for them in their parent directory as what it
> does for PCI bridge. For example, device 01:00.0 is the parent and 01:00.1
> is the child, I'd like to put a symbol link into
> /sys/bus/pci/device/0000:01:00.0/child/ which points to
> /sys/bus/pci/device/0000:01:00.1.  This can let user space application
> know the relationship between this two devices.

If .1 is really the child of .0, then make it so in the sysfs tree in
the first place with the topology of the devices.  That way you don't
need any special "child" directory, as that would be different from all
other device types in the system.

thanks,

greg k-h
