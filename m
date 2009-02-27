Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbZB0HUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbZB0HUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZB0HUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:20:40 -0500
Received: from colo.lackof.org ([198.49.126.79]:40478 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbZB0HUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:20:39 -0500
Date: Fri, 27 Feb 2009 00:19:38 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
Message-ID: <20090227071937.GC9883@colo.lackof.org>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com> <20090214225910.GA1515@colo.lackof.org> <20090226025035.GA12973@yzhao-otc.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226025035.GA12973@yzhao-otc.sh.intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:50:35AM +0800, Yu Zhao wrote:
...
> > Yu,
> > Can you please add something to Documentation/PCI/pci.txt?
> > New API I'm seeing are:
> > +extern int pci_enable_ats(struct pci_dev *dev, int ps);
> > +extern void pci_disable_ats(struct pci_dev *dev);
> > +extern int pci_ats_queue_depth(struct pci_dev *dev);
> 
> Yes, I'll document these new API.

Thank you! (But maybe this was a bad idea)

> > Do these also need to be EXPORT_SYMBOL_GPL() as well?
> > Or are drivers never expected to call the above?
> 
> PCI device driver shouldn't use these API, only IOMMU driver (can't be module)
> would use them. Anyway it's a good idea to export them :-)

No, it's not a good idea to export if only IOMMU drivers should use them.
Exporting the symbols can only lead to abuse.

In fact, my request to add them to pci.txt sounds like a bad idea.
I was thinking this was for device drivers.

In any case, documenting the API and intended use is good.
It's probably sufficient to add comments where the functions are defined.

thanks,
grant
