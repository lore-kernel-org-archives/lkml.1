Return-Path: <linux-kernel-owner+w=401wt.eu-S1161556AbXDYBNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161556AbXDYBNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161568AbXDYBNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:13:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161562AbXDYBNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:13:13 -0400
Message-ID: <462EAB13.4040104@zytor.com>
Date: Tue, 24 Apr 2007 18:12:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: David Miller <davem@davemloft.net>, ashok.raj@intel.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices
 cannot address entire range.
References: <200704242312.54738.ak@suse.de> <20070424213835.GB31920@linux-os.sc.intel.com> <20070424.145026.128110905.davem@davemloft.net> <200704250003.57968.ak@suse.de>
In-Reply-To: <200704250003.57968.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tuesday 24 April 2007 23:50:26 David Miller wrote:
>> From: Ashok Raj <ashok.raj@intel.com>
>> Date: Tue, 24 Apr 2007 14:38:35 -0700
>>
>>> Its not clear if we have a very generic device breakage.. most devices
>>> on these platforms are going to be more recent, (except maybe some
>>> legacy fd)... 
>> I'm not so sure, there are some "modern" sound cards that have
>> a 31-bit DMA addressing limitation because they use the 31st
>> bit as a status bit in their DMA descriptors :-)
> 
> There's also a 2GB only megaraid RAID controller that's pretty popular 
> because Dell shipped it for a long time.
> 

You can probably find almost any possible bitmask if you look long 
enough.  Hardware vendors are notorious for this kind of "optimizations".

	-hpa
