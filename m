Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYI0CDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYI0CDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYI0CDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:03:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38029 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYI0CDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:03:31 -0400
Message-ID: <48DD92AA.4050900@zytor.com>
Date: Fri, 26 Sep 2008 18:55:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: "akataria@vmware.com" <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: Use CPUID to communicate with the hypervisor.
References: <1222472815.29886.43.camel@alok-dev1>	 <48DD799C.3070706@zytor.com> <1222475403.29886.57.camel@alok-dev1> <48DD7F1A.4060703@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15718417A@orsmsx505.amr.corp.intel.com>
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A15718417A@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
>>>
>> Agreed.  However, that's obviously beyond our immediate control.
> 
> Well, actually it's under full control of the Linux community because the _kernel_ defines such virtual or semi-hardware features. I'm not sure if that particular value (0x40000010) is proper, but we should be able to pick reasonable ones/ranges.
> 

Uhm, no, they're defined by the _hypervisor_.

	-hpa
