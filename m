Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0CASda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:33:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:37532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab0CASd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:33:28 -0500
Message-ID: <4B8C081C.5050706@kernel.org>
Date: Mon, 01 Mar 2010 10:31:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       hpa@zytor.com, garyhade@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com
Subject: Re: [PATCH -v11] x86: fix out of order of gsi -- partial
References: <4B882182.4030205@kernel.org> <20100228080941.GD14205@elte.hu> <4B8A31DD.4000408@kernel.org> <201003011540.17866.trenn@suse.de>
In-Reply-To: <201003011540.17866.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 06:40 AM, Thomas Renninger wrote:
> On Sunday 28 February 2010 10:05:33 Yinghai Lu wrote:
>> On 02/28/2010 12:09 AM, Ingo Molnar wrote:
>>>
>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> From: Eric W. Biederman <ebiederm@xmission.com>
>>>>
>>>> found IBM x3950 will have problem after
>>>>
>>>> |commit b9c61b70075c87a8612624736faf4a2de5b1ed30
>>>
>>> Have you seen the commit notifications i sent for the v8 patches:
>>>
>>> Commit-ID:  ca8c764cb39bf6cade71933b38e8c830eb8b73c6
>>> Commit-ID:  519d637a93116ffbcd50e9e3f2591f41584f372c
>>>
>>> Those include a much improved changelogs - please adopt those. (and preferably 
>>> send deltas against tip:tmp.x86/apic.)
>>
>> please drop those two.
>>  
>> will send v12 to you.
> Eh, not sure, but could it be Ingo forgot the 2nd
> part of v12?
> 
> In linux-2.6-tip I see:
> commit fad539956c9e69749a03f7817d22d1bab87657bf
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Sun Feb 28 01:06:34 2010 -0800
> 
>     x86: Fix out of order of gsi
> 
> which equals:
> [PATCH -v12 1/2] x86: fix out of order of gsi -- partial
> 
> but I cannot see:
> [PATCH -v12 2/2] x86: fix out of order of gsi - full
> 
> Also this machine booted/worked fine up to 2.6.30.
> Any chance this will get addressed in stable@ kernel(s)?
> 

patch 1/2: should be with stable@ #.32 and #.33

patch 2/2: could be only with 2.6.34 or 2.6.35

Thanks

Yinghai
