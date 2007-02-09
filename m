Return-Path: <linux-kernel-owner+w=401wt.eu-S1422997AbXBILyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422997AbXBILyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423021AbXBILyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:54:38 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:39005 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422997AbXBILyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:54:38 -0500
Message-ID: <45CC60FD.6080606@vmware.com>
Date: Fri, 09 Feb 2007 03:54:37 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: virtualization@lists.osdl.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
References: <1171012296.2718.26.camel@localhost.localdomain> <1171018812.2718.66.camel@localhost.localdomain> <45CC5771.1070309@vmware.com> <200702091250.06482.ak@muc.de>
In-Reply-To: <200702091250.06482.ak@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Yes, it is a bit, umm, innovative.  If it is going to be kept, even if 
>> just for devel logging, you should disable interrupts around it.  
>> Changing segments is not a normal thing to do.
>>     
>
> Actually that wouldn't be needed because interrupts are not allowed to do any 
> user accesses. And contrary to the name it doesn't actually change
> the segment registers, only state used by *_user.
>   

My bad, I fell for the same mistake as everyone.  Set_fs is just way too 
confusing of a name now.  But good to know interrupts must be disable in 
such a circumstance.

Zach
