Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0BBGMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:12:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab0BBGMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:12:18 -0500
Message-ID: <4B67C0F9.2020202@zytor.com>
Date: Mon, 01 Feb 2010 22:06:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH V10] RO/NX protection for loadable kernel modules
References: <817ecb6f1002011539g3f30416fi60c7c5222cab8f3@mail.gmail.com> <201002021429.38331.rusty@rustcorp.com.au>
In-Reply-To: <201002021429.38331.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 07:59 PM, Rusty Russell wrote:
> On Tue, 2 Feb 2010 10:09:53 am Siarhei Liakh wrote:
>> This patch is a logical extension of the protection provided by
>> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
>> module_core and module_init into three logical parts each and setting
>> appropriate page access permissions for each individual section:
>>
>>   1. Code: RO+X
>>   2. RO data: RO+NX
>>   3. RW data: RW+NX
>
> Thanks, applied!

I also applied this to the -tip tree... do you prefer to carry it or 
should I leave it as is?

	-hpa
