Return-Path: <linux-kernel-owner+w=401wt.eu-S934719AbXLNAUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbXLNAUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764362AbXLNAU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:20:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:57703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760863AbXLNAU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:20:27 -0500
Date: Thu, 13 Dec 2007 16:19:32 -0800
From: Greg KH <gregkh@suse.de>
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Message-ID: <20071214001932.GA10389@suse.de>
References: <20071213235543.568682000@intel.com> <20071213235712.813201000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213235712.813201000@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 03:55:51PM -0800, venkatesh.pallipadi@intel.com wrote:
> Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.
> 
> TBD: Do we need the ioctl interface to sysfs or get the type attribute
> through a different sysfs file. And then actually specify the attribute
> while doing pci_mmap_page_range ;-)

Woah!  No, no ioctls on sysfs files, sorry.  Not going to happen, do
this on a /dev file if you want to have ioctls...

thanks,

greg k-h
