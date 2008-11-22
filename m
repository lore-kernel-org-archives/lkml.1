Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbYKVHEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbYKVHEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYKVHEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:04:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:16916 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbYKVHEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:04:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,649,1220252400"; 
   d="scan'208";a="80580782"
Message-ID: <4927AEDF.4070808@intel.com>
Date: Sat, 22 Nov 2008 15:03:59 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "bjorn.helgaas@hp.com" <bjorn.helgaas@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "horms@verge.net.au" <horms@verge.net.au>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081121205746.GA3639@kroah.com>
In-Reply-To: <20081121205746.GA3639@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Nov 22, 2008 at 02:36:05AM +0800, Yu Zhao wrote:
>> Greetings,
>>
>> Following patches are intended to support SR-IOV capability in the
>> Linux kernel. With these patches, people can turn a PCI device with
>> the capability into multiple ones from software perspective, which
>> will benefit KVM and achieve other purposes such as QoS, security,
>> and etc.
>>
>> The Physical Function and Virtual Function drivers using the SR-IOV
>> APIs will come soon!
> 
> Thanks for respining these patches, but I think we really need to see a
> driver using this in order to get an idea of how it will be used.

Yes, the PF driver patch and the VF driver for Intel 82576 NIC will be 
available next week. Both PF/VF drivers are testing versions. The PF 
driver patch is based on the lasted kernel IGB driver 
(drivers/net/igb/), and uses SR-IOV v7 API. The VF driver is a totally 
new NIC driver, it looks like other normal PCI NIC drivers.

> Also, the Xen and KVM people need to agree on the userspace interface
> here, perhaps also getting some libvirt involvement as well, as they are
> going to be the ones having to use this all the time.

I'll keep KVM/Xen people updated on the user level interface and let 
them comment based on a real usage model of the Intel 82576 NIC after 
PF/VF drivers are available.

Regards,
Yu
