Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZEZIMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZEZIMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZEZIMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:12:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbZEZIMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:12:05 -0400
Message-ID: <4A1BA44E.7040802@redhat.com>
Date: Tue, 26 May 2009 11:11:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Huang Ying <ying.huang@intel.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] KVM: MCE: Add MCE support to KVM
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com> <4A105DE2.8090200@redhat.com> <4A1AD816.1060702@siemens.com> <4A1ADED5.4020605@redhat.com> <4A1AE04F.9070808@siemens.com> <4A1AE157.3010609@siemens.com>
In-Reply-To: <4A1AE157.3010609@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
>> Well, if I look at the definition of MCI_STATUS_VAL as (1UL<<63),
>> something tells me: "Hey, only use me on 64-bit hosts!" But I have no
>> clue about details of this stuff, and from a second glance at it is
>> seems to include at least some parts that are valid on 32-bit as well.
>>     
>
> Ah, interesting: /someone/ removed the #ifdef __x86_64__ from
> arch/x86/include/asm/mce.h, but that's not mainline yet...
>   

Well that someone missed the MCI_STATUS_VAL bit.  Do you see anything 
else fishy in there?

-- 
error compiling committee.c: too many arguments to function

