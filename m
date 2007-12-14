Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbXLNF7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbXLNF7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 00:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXLNF7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 00:59:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:52577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXLNF7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 00:59:13 -0500
Date: Thu, 13 Dec 2007 22:02:03 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, rdreier@cisco.com,
       torvalds@linux-foundation.org, airlied@skynet.ie, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 08/12] PAT 64b: coherent mmap and sysfs bin ioctl
Message-ID: <20071214060203.GA10100@suse.de>
References: <20071213235543.568682000@intel.com> <20071213235712.813201000@intel.com> <m18x3yq633.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18x3yq633.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:59:44PM -0700, Eric W. Biederman wrote:
> venkatesh.pallipadi@intel.com writes:
> 
> > Forward port of coherent-mmap.patch and sysfs-bin-ioctl.patch to x86 tree.
> >
> > TBD: Do we need the ioctl interface to sysfs or get the type attribute
> > through a different sysfs file. And then actually specify the attribute
> > while doing pci_mmap_page_range ;-)
> 
> This ioctl is not connected up.  So regardless of the wisdom of ioctls on
> sysfs adding the infrastructure and then not using it is broken.

Ok, I guess the "use an ioctl on a binary file in sysfs for PCI devices"
makes a bit more sense (hint, next time explain this in the changelog
instead of just saying that it is being added), but I would like to see
how this is all hooked up before passing final judgement on it.

thanks,

greg k-h
