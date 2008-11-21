Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYKUVB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYKUVB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 16:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYKUVBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 16:01:17 -0500
Received: from kroah.org ([198.145.64.141]:45366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752187AbYKUVBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 16:01:16 -0500
Date: Fri, 21 Nov 2008 12:57:46 -0800
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: linux-pci@vger.kernel.org, achiang@hp.com, bjorn.helgaas@hp.com,
       grundler@parisc-linux.org, mingo@elte.hu, jbarnes@virtuousgeek.org,
       matthew@wil.cx, randy.dunlap@oracle.com, rdreier@cisco.com,
       horms@verge.net.au, yinghai@kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Message-ID: <20081121205746.GA3639@kroah.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 02:36:05AM +0800, Yu Zhao wrote:
> Greetings,
> 
> Following patches are intended to support SR-IOV capability in the
> Linux kernel. With these patches, people can turn a PCI device with
> the capability into multiple ones from software perspective, which
> will benefit KVM and achieve other purposes such as QoS, security,
> and etc.
> 
> The Physical Function and Virtual Function drivers using the SR-IOV
> APIs will come soon!

Thanks for respining these patches, but I think we really need to see a
driver using this in order to get an idea of how it will be used.

Also, the Xen and KVM people need to agree on the userspace interface
here, perhaps also getting some libvirt involvement as well, as they are
going to be the ones having to use this all the time.

thanks,

greg k-h
