Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYKZRBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYKZRBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYKZRBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:01:19 -0500
Received: from kroah.org ([198.145.64.141]:40238 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753143AbYKZRBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:01:17 -0500
Date: Wed, 26 Nov 2008 08:59:33 -0800
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       xen-devel@lists.xensource.com,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 0/3] introduction
Message-ID: <20081126165933.GB28251@kroah.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126140303.GA13641@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 10:03:03PM +0800, Yu Zhao wrote:
> SR-IOV drivers of Intel 82576 NIC are available. There are two parts
> of the drivers: Physical Function driver and Virtual Function driver.
> The PF driver is based on the IGB driver and is used to control PF to
> allocate hardware specific resources and interface with the SR-IOV core.
> The VF driver is a new NIC driver that is same as the traditional PCI
> device driver. It works in both the host and the guest (Xen and KVM)
> environment.
> 
> These two drivers are testing versions and they are *only* intended to
> show how to use SR-IOV API.

That's funny, as some distros are already shipping this driver.  You
might want to tell them that this is an "example only" driver and not to
be used "for real"... :(

greg k-h
