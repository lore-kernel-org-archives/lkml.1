Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYLAMuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYLAMuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYLAMuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:50:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:47772 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYLAMui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:50:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,695,1220252400"; 
   d="scan'208";a="469781548"
Date: Tue, 2 Dec 2008 00:54:52 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Greg KH <greg@kroah.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 0/3] introduction
Message-ID: <20081201165452.GD1464@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com> <20081126165933.GB28251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126165933.GB28251@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 12:59:33AM +0800, Greg KH wrote:
> On Wed, Nov 26, 2008 at 10:03:03PM +0800, Yu Zhao wrote:
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
> 
> That's funny, as some distros are already shipping this driver.  You
> might want to tell them that this is an "example only" driver and not to
> be used "for real"... :(

Maybe they are shipping another version, not this one. This one is really
a experimental patch, it's just created a week before...
