Return-Path: <linux-kernel-owner+w=401wt.eu-S935524AbXLNAuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935524AbXLNAuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762826AbXLNAuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:50:12 -0500
Received: from colin.muc.de ([193.149.48.1]:2442 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934103AbXLNAuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:50:10 -0500
Date: 14 Dec 2007 01:43:26 +0100
Date: Fri, 14 Dec 2007 01:43:26 +0100
From: Andi Kleen <ak@muc.de>
To: Greg KH <gregkh@suse.de>
Cc: venkatesh.pallipadi@intel.com, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Message-ID: <20071214004326.GB2735@muc.de>
References: <20071213235543.568682000@intel.com> <20071213235712.813201000@intel.com> <20071214001932.GA10389@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214001932.GA10389@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 04:19:32PM -0800, Greg KH wrote:
> On Thu, Dec 13, 2007 at 03:55:51PM -0800, venkatesh.pallipadi@intel.com wrote:
> > Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.
> > 
> > TBD: Do we need the ioctl interface to sysfs or get the type attribute
> > through a different sysfs file. And then actually specify the attribute
> > while doing pci_mmap_page_range ;-)
> 
> Woah!  No, no ioctls on sysfs files, sorry.  Not going to happen, do
> this on a /dev file if you want to have ioctls...

That would require putting the whole PCI bus hierarchy into /dev.
We could do that, but for what would we still need /sys then ? @)

Anyways if you can suggest a better interface please do, but please think first.

-Andi
