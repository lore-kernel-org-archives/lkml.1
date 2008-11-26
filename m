Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYKZUPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYKZUPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYKZUPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:15:01 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41842 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbYKZUPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:15:00 -0500
Message-ID: <492DAE38.3050809@garzik.org>
Date: Wed, 26 Nov 2008 15:14:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Yu Zhao <yu.zhao@intel.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       xen-devel@lists.xensource.com,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 0/3] introduction
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com>
In-Reply-To: <20081126140303.GA13641@yzhao12-linux.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yu Zhao wrote:
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
> 
> Intel 82576 NIC specification can be found at:
> http://download.intel.com/design/network/datashts/82576_Datasheet_v2p1.pdf
> 
> [SR-IOV driver example 1/3] PF driver: allocate hardware specific resource
> [SR-IOV driver example 2/3] PF driver: integrate with SR-IOV core
> [SR-IOV driver example 3/3] VF driver tar ball

Please copy netdev@vger.kernel.org on all network-related patches.  This 
is where the network developers live, and all patches on this list are 
automatically archived for review and handling at 
http://patchwork.ozlabs.org/project/netdev/list/

	Jeff



