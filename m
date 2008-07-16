Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYGPFlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYGPFlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYGPFkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:40:53 -0400
Received: from mga06.intel.com ([134.134.136.21]:41901 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716AbYGPFkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:40:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,371,1212390000"; 
   d="scan'208";a="418600072"
Message-ID: <487D89E3.9070604@linux.intel.com>
Date: Wed, 16 Jul 2008 07:40:51 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
Subject: Re: acpi based pci gap calculation  - v3
References: <1216148382.6135.21.camel@alok-dev1> <200807151328.00739.jbarnes@virtuousgeek.org> <1216155256.6135.25.camel@alok-dev1> <200807151553.41403.jbarnes@virtuousgeek.org>
In-Reply-To: <200807151553.41403.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Tuesday, July 15, 2008 1:54 pm Alok Kataria wrote:
>> I have tested it with couple of different BIOS settings and it seems to
>> work as it should.
>>
>>> Most of the PCI bugs we
>>> have at the moment are related to PCI resource allocation failures.  My
>>> hope is that finding more space will fix most of them.  Assuming this
>>> patch doesn't have any dependencies, I can put it in my linux-next
>>> branch.
>> No dependencies, I had added a function e820_search_gap which is used by
>> this patch. This function is already in the mainline tree.
>> Thanks for applying.
> 
> Ok, I stuffed it in my linux-next branch.  I'll let it sit there for a day or 
> so though, just to shake out any build problems etc. in linux-next before 
> asking Linus to pull the whole lot.

For me it seems a little risky to push up that early. I think it would 
be better to let it sit longer in linux-next for this. After all this is 
a major change how IO resources are allocated. That is why I didn't pull
it into the ACPI release branch.

-Andi

