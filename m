Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZF2NST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZF2NST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZF2NSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:18:04 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:33080 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZF2NSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:18:03 -0400
X-SpamScore: -40
X-BigFish: VPS-40(zz1432R98dR936eN4015L1805M9371Pzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KM04XP-01-L7L-01
Date: Mon, 29 Jun 2009 15:17:50 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v3] KVM support for 1GB pages
Message-ID: <20090629131749.GO5139@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <4A41E714.5070701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A41E714.5070701@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Jun 2009 13:17:50.0400 (UTC) FILETIME=[0093DC00:01C9F8BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 11:43:00AM +0300, Avi Kivity wrote:
> On 06/19/2009 04:16 PM, Joerg Roedel wrote:
>> Hi,
>>
>> this is the third version of the patches for KVM to support 1GB pages. Changes
>> to the last version include:
>>
>> 	- changed reporting of 1GB page support to userspace to use
>> 	  SUPPORTED_CPUID ioctl
>> 	- added support for 1GB pages to the software page walker code too
>>
>> This code still only can make use of 1GB pages with nested paging enabled. I
>> will give the shadow paging code another debug round soon. Please comment or
>> consider to apply these patches.
>>
>> Thanks,
>>
>> 	Joerg
>>
>> Shortlog:
>>
>> Joerg Roedel (8):
>>        hugetlbfs: export vma_kernel_pagsize to modules
>>        kvm: change memslot data structures for multiple hugepage sizes
>>    
>
> At Marcelo's suggestion I've applied the first two patches, to reduce  your
> rebase load.

Thank you. I will soon fix your objection on the existing patches and resend
them. After that I continue to look at gbpages with shadow paging again.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

