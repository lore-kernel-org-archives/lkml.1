Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZCITqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZCITqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZCITqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:46:31 -0400
Received: from kroah.org ([198.145.64.141]:59443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752097AbZCITqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:46:30 -0400
Date: Mon, 9 Mar 2009 12:39:01 -0700
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 4/7] PCI: add SR-IOV API for Physical Function
	driver
Message-ID: <20090309193901.GA15011@kroah.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-5-git-send-email-yu.zhao@intel.com> <20090306203717.GG25995@parisc-linux.org> <20090309082505.GC4638@yzhao-otc.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309082505.GC4638@yzhao-otc.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 04:25:05PM +0800, Yu Zhao wrote:
> > > +	pci_device_add(virtfn, virtfn->bus);
> > 
> > Greg is probably going to ding you here for adding the device, then
> > creating the symlinks.  I believe it's now best practice to create the
> > symlinks first, so there's no window where userspace can get confused.
> 
> Yes, but unfortunately we can't create links before adding a device.
> I double checked device_add(), there is no place for those links to be
> created before it sends uevent. So for now, we have to trigger another
> uevent for those links.

What exactly are you trying to do with a symlink here that you need to
do it this way?  I vaguely remember you mentioning this in the past, but
I thought you had dropped the symlinks after our conversation about this
very problem.

thanks,

greg k-h
