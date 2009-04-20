Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZDTLDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZDTLDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZDTLDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:03:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbZDTLDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:03:01 -0400
Message-ID: <49EC565B.2090806@redhat.com>
Date: Mon, 20 Apr 2009 14:02:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gerd Hoffmann <kraxel@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239332455.6384.108.camel@yhuang-dev.sh.intel.com> <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <20090420100421.GX14687@one.firstfloor.org>
In-Reply-To: <20090420100421.GX14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> It depends if the MSR may be considered global, or is required to be 
>> per-cpu.  Need to refresh my memory on this, but I remember reading this 
>>     
>
> Machine Check MSRs need to be per CPU. The latest kernels have some support
> for "shared banks" (between CPUs) but it's better to not have it and
> older OS don't like it.
>   

In the case of the hypercall page MSR, it is global and shared among all 
processors.

-- 
error compiling committee.c: too many arguments to function

