Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbZHFBhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbZHFBhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZHFBhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:37:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57687 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZHFBhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:37:35 -0400
Message-ID: <4A7A3445.60903@redhat.com>
Date: Thu, 06 Aug 2009 09:39:17 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain> <m1eirqtmey.fsf@fess.ebiederm.org>
In-Reply-To: <m1eirqtmey.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
>
>   
>> This series of patch implements automatically reserved memory for crashkernel,
>> by introducing a new boot option "crashkernel=auto". This idea is from Neil.
>>
>> In case of breaking user-space applications, it modifies this boot option after
>> it decides how much memory should be reserved.
>>
>> On different arch, the threshold and reserved memory size is different. Please
>> refer patch 7/7 which contains an update for the documentation.
>>
>> Note: This patchset was only tested on x86_64 with differernt memory sizes.
>>     
>
> This seems like a silly hard code. Especially for a feature distros don't
> care enough about to implement a working initrd for.
>
> Has anyone bothered to justify those large amounts of memory?
> Where does the 128M go?
>   

If 128M is too big, we can make it to be 64M, that is no problem.
I am very open to this. :)

> Please pardon me for being a cynic but I don't see the command line option
> being the bottleneck for real users to make this work.
>
>   
Well, take /me as an example, to be honest, I still have no idea how 
much memory I should reserve for s390/sh, if I would use kdump on sh, it 
*is* my bottleneck.

Thanks.


