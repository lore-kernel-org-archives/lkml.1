Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758100AbYLQGG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYLQGG1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 01:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYLQGGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 01:06:15 -0500
Received: from kroah.org ([198.145.64.141]:60591 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750903AbYLQGGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 01:06:14 -0500
Date: Tue, 16 Dec 2008 22:06:08 -0800
From: Greg KH <greg@kroah.com>
To: Jike Song <albcamus@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yu Zhao <yu.zhao@intel.com>,
        linux-pci@vger.kernel.org, achiang@hp.com, bjorn.helgaas@hp.com,
        grundler@parisc-linux.org, mingo@elte.hu, matthew@wil.cx,
        randy.dunlap@oracle.com, rdreier@cisco.com, horms@verge.net.au,
        yinghai@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Message-ID: <20081217060608.GA12618@kroah.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812161523.55238.jbarnes@virtuousgeek.org> <49486602.5000108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49486602.5000108@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 10:37:54AM +0800, Jike Song wrote:
> Jesse Barnes wrote:
> > Given a respin of 10-13 I think it's reasonable to merge this into 2.6.29, but 
> > I'd be much happier about it if we got some driver code along with it, so as 
> > not to have an unused interface sitting around for who knows how many 
> > releases.  Is that reasonable?  Do you know if any of the corresponding PF/VF 
> > driver bits are ready yet?
> 
> Hi Jesse, 
> 
> Yu Zhao has posted a patch set with subject "SR-IOV driver example" 
> at November 26, which illustrated the usage of SR-IOV API in Intel 82576 VF/PF
> drivers;-)

Yes, but that driver was soundly rejected by the network driver
maintainers, so I wouldn't go around showing that as your primary
example of how to use this interface :)

The point is valid, I don't think these apis should go into the tree
without a driver or some other code using them.  Otherwise they make no
sense at all to have in-tree.

thanks,

greg k-h
