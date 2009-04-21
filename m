Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZDUQRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZDUQRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZDUQRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:17:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34039 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbZDUQRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:17:09 -0400
Message-ID: <49EDF17F.1010903@redhat.com>
Date: Tue, 21 Apr 2009 19:17:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EDEE93.30103@codemonkey.ws>
In-Reply-To: <49EDEE93.30103@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
>>
>> Right now everything in the vcpu is emulated in the kernel.  
>> Everything else is emulated either in the kernel (irqchip) or in 
>> userspace.  This makes things easier to understand, and is more 
>> future friendly if more cpu features become virtualized by hardware.
>
> Except cpuid, which is handled in userspace, sort of :-)  I think the 
> same arguments apply here too.

No, cpuid is handled in the kernel (exactly to have everything cpuish in 
kernel).  It is *configured* from userspace, but then so is everything.

-- 
error compiling committee.c: too many arguments to function

