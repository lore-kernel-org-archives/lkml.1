Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbZA3B26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbZA3B26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZA3B2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:28:50 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:54088 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbZA3B2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:28:49 -0500
Message-ID: <498257CC.40902@vmware.com>
Date: Thu, 29 Jan 2009 17:28:44 -0800
From: Oleg Orel <oorel@vmware.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "'avi@qumranet.com'" <avi@qumranet.com>,
       "'yaniv@qumranet.com'" <yaniv@qumranet.com>,
       Bhavesh Davda <bhavesh@vmware.com>,
       Mallik Mahalingam <mallik@vmware.com>,
       Jagannath Krishnan <krishnan@vmware.com>, Adar Dembo <adar@vmware.com>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: Intel IOMMU on Dell Latitude E6400, Lenovo X200 & Dell Precision
 T5400
References: <49822738.5060103@vmware.com> <A6AD88C3F2289247BE726C37303E1EB8927A8E8E@orsmsx505.amr.corp.intel.com>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8927A8E8E@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yu, Fenghua wrote:
>   
>> We had reported more details @
>> https://bugzilla.redhat.com/show_bug.cgi?id=479996 and
>> http://bugzilla.kernel.org/show_bug.cgi?id=11821
>>     
>
> Look into http://bugzilla.kernel.org/show_bug.cgi?id=11821
> and find that:
>
> wlan0: Failed to config new SSID to the low-level driver
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> IP: [<ffffffff8037cf1f>] pci_find_upstream_pcie_bridge+0x1f/0xa0
> ...
> [<ffffffff80386808>] get_domain_for_dev+0x58/0x620
>  [<ffffffff8029574d>] ? __alloc_pages_internal+0xed/0x4f0
>  [<ffffffff803870f8>] get_valid_domain_for_dev+0x18/0x150
>  [<ffffffff803875e7>] intel_map_single+0x47/0x160
>  [<ffffffff802b8726>] ? alloc_pages_current+0x76/0xf0
>  [<ffffffff8038777f>] intel_alloc_coherent+0x7f/0xb0
> ...
>
> Wireless LAN could cause the NULL pointer access in get_domain_for_dev() which is IOMMU function.
>
> As an experiment, could you disable wireless lan on your machine and try to boot IOMMU kernel?
>
> Thanks.
>
> -Fenghua
>   
Yu,
I did it already yesterday. It didn't help. It fact I had disable all 
disableble devices, also, on T5400 when is failing as well, we do not 
have a wireless.

