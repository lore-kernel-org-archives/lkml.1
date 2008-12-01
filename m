Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYLAMfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYLAMfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYLAMfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:35:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:5306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbYLAMfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:35:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,695,1220252400"; 
   d="scan'208";a="469760904"
Date: Tue, 2 Dec 2008 00:39:15 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 0/3] introduction
Message-ID: <20081201163914.GA1464@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com> <492DAE38.3050809@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492DAE38.3050809@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 04:14:48AM +0800, Jeff Garzik wrote:
> Yu Zhao wrote:
> > SR-IOV drivers of Intel 82576 NIC are available. There are two parts
> > of the drivers: Physical Function driver and Virtual Function driver.
> > The PF driver is based on the IGB driver and is used to control PF to
> > allocate hardware specific resources and interface with the SR-IOV core.
> > The VF driver is a new NIC driver that is same as the traditional PCI
> > device driver. It works in both the host and the guest (Xen and KVM)
> > environment.
> > 
> > These two drivers are testing versions and they are *only* intended to
> > show how to use SR-IOV API.
> > 
> > Intel 82576 NIC specification can be found at:
> > http://download.intel.com/design/network/datashts/82576_Datasheet_v2p1.pdf
> > 
> > [SR-IOV driver example 1/3] PF driver: allocate hardware specific resource
> > [SR-IOV driver example 2/3] PF driver: integrate with SR-IOV core
> > [SR-IOV driver example 3/3] VF driver tar ball
> 
> Please copy netdev@vger.kernel.org on all network-related patches.  This 
> is where the network developers live, and all patches on this list are 
> automatically archived for review and handling at 
> http://patchwork.ozlabs.org/project/netdev/list/

Will do.

Thanks,
Yu
