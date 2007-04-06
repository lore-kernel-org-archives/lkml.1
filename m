Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXDFADh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXDFADh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXDFADh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:03:37 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55226 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbXDFADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:03:33 -0400
Message-ID: <46158DE1.4050508@vmware.com>
Date: Thu, 05 Apr 2007 17:01:37 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de>
In-Reply-To: <200704060154.41574.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Friday 06 April 2007 01:29:56 Zachary Amsden wrote:
>   
>> I noticed this never got applied.  There was some feedback which I did 
>> not include in this patch because I think it is inappropriate to touch 
>> code outside vmi.c at this point for 2.6.21. 
>>     
>
> I think it is. That is why i didn't apply it.
>   

Well at this point, the "proper" fix is dependent on Jeremy's 
kmap_atomic_pte changes, which are definitely too late to pull into 
2.6.21.  Can we just apply this patch please?

Thanks,

Zach
