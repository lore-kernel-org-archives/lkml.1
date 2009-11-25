Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZKYC1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZKYC1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 21:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbZKYC1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 21:27:03 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:35364 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758247AbZKYC1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 21:27:03 -0500
Message-ID: <4B0C95B7.5070409@internode.on.net>
Date: Wed, 25 Nov 2009 12:55:59 +1030
From: indexer <indexer@internode.on.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug 14658] Regression in efi.c
References: <bug-14658-6666@http.bugzilla.kernel.org/>	 <200911212017.nALKHLSC029634@demeter.kernel.org>	 <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain>	 <4B09F685.2080201@internode.on.net>	 <alpine.LFD.2.00.0911231034090.24119@localhost.localdomain>	 <4B0A6DCA.70805@internode.on.net>  <4B0C7BBE.3040703@internode.on.net> <1259110243.7068.8.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1259110243.7068.8.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Hi, William,
>
> On Wed, 2009-11-25 at 08:35 +0800, indexer wrote: 
>   
>> To whom it may concern
>>
>> I have redone the bisect and i believe the versions i originally stated 
>> were wrong. I apologise for this mistake
>>
>> commit 7bd867dfb4e0357e06a3211ab2bd0e714110def3
>> Author: Feng Tang <feng.tang@intel.com>
>> Date:   Thu Sep 10 10:48:56 2009 +0800
>>
>>     x86: Move get/set_wallclock to x86_platform_ops
>>    
>>     get/set_wallclock() have already a set of platform dependent
>>     implementations (default, EFI, paravirt). MRST will add another
>>     variant.
>>    
>>     Moving them to platform ops simplifies the existing code and minimizes
>>     the effort to integrate new variants.
>>     
>
> Now Legacy RTC code instead of EFI get/set_wallclock is used on x86_64.
> Your test shows that before this patch, kernel can boot on your system,
> but can not boot after that?
>
> Best Regards,
> Huang Ying
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Huang Ying

Yes that is correct, i cant boot after this patch was applied, but 
former to this patch, my system would boot.

William
