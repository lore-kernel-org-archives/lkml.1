Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYKNAf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYKNAf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYKNAfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:35:50 -0500
Received: from gw.goop.org ([64.81.55.164]:42095 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYKNAft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:35:49 -0500
Message-ID: <491CC7E1.6000302@goop.org>
Date: Thu, 13 Nov 2008 16:35:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 25 of 38] xen mtrr: Add mtrr_ops support for Xen mtrr
References: <61b4b844fb80206fbda1.1226603423@abulafia.goop.org> <1226608128.19068.10.camel@blaa>
In-Reply-To: <1226608128.19068.10.camel@blaa>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> On Thu, 2008-11-13 at 11:10 -0800, Jeremy Fitzhardinge wrote:
>
>   
>> diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
>> new file mode 100644
>> --- /dev/null
>> +++ b/arch/x86/kernel/cpu/mtrr/xen.c
>> @@ -0,0 +1,59 @@
>>     
> ...
>   
>> +
>> +/* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
>> + * working userland mtrr support. */
>> +static struct mtrr_ops xen_mtrr_ops = {
>> +	.vendor            = X86_VENDOR_UNKNOWN,
>> +//	.set               = xen_set_mtrr,
>> +//	.get               = xen_get_mtrr,
>> +	.get_free_region   = generic_get_free_region,
>> +//	.validate_add_page = xen_validate_add_page,
>> +	.have_wrcomb       = positive_have_wrcomb,
>> +	.use_intel_if	   = 0,
>> +	.num_var_ranges	   = xen_num_var_ranges,
>> +};
>>     
>
> ...
>
> I'm vague on the details now, but looking back at the dom0 patch set
> here:
>
> http://git.et.redhat.com/?p=linux-2.6-dom0-pvops.git;a=shortlog;h=55abc194080b5cf31cd66f5e35e8e5c5af2aa927
>
> I see we did have a bunch more mtrr work e.g. fixing the TODO above:
>
> http://git.et.redhat.com/?p=linux-2.6-dom0-pvops.git;a=commitdiff;h=93f779bf3d79f28d0933bfbc53f7b8c5b6496081
>   

Yes, the mtrr changes are incomplete.  I started on them as much as 
necessary to get things booting, and then left the rest to revisit.  
It's not a particularly pretty part of the kernel, and so I was hoping 
some magic beautification fairy would visit it before I needed to touch 
it more...

    J
