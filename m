Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYKQBrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYKQBrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 20:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYKQBrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 20:47:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:47395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbYKQBq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 20:46:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,615,1220252400"; 
   d="scan'208";a="463801660"
Message-ID: <4920CD0F.8070107@intel.com>
Date: Mon, 17 Nov 2008 09:46:55 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Andi Kleen <andi@firstfloor.org>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com>	<894107.30288.qm@web45108.mail.sp1.yahoo.com>	<20081106164919.GA4099@kroah.com>	<0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>	<20081106183630.GD11773@parisc-linux.org>	<491371F0.7020805@codemonkey.ws> <87d4h7pnnm.fsf__4937.77150190926$1226071173$gmane$org@basil.nowhere.org> <491B5B97.2000407@codemonkey.ws> <492044A7.3080107@redhat.com>
In-Reply-To: <492044A7.3080107@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Anthony Liguori wrote:
>> I don't think it's established that PV/VF will have less latency than 
>> using virtio-net.  virtio-net requires a world switch to send a group 
>> of packets.  The cost of this (if it stays in kernel) is only a few 
>> thousand cycles on the most modern processors.
>>
>> Using VT-d means that for every DMA fetch that misses in the IOTLB, 
>> you potentially have to do four memory fetches to main memory.  There 
>> will be additional packet latency using VT-d compared to native, it's 
>> just not known how much at this time.
> 
> If the IOTLB has intermediate TLB entries like the processor, we're 
> talking just one or two fetches.  That's a lot less than the cacheline 
> bouncing that virtio and kvm interrupt injection incur right now.
> 

The PCI SIG Address Translation Service (ATS) specifies a way that uses 
an Address Translation Cache (ATC) in the Endpoint to reduce the latency.

The Linux kernel support for ATS capability will come soon.

Thanks,
Yu
