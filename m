Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbYBLMKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbYBLMKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYBLMKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:10:43 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46833 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751040AbYBLMKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:10:42 -0500
Message-ID: <47B18CB4.7090408@linux.vnet.ibm.com>
Date: Tue, 12 Feb 2008 17:40:28 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       anton@samba.org, paulus@samba.org, rusty@rustcorp.com.au
Subject: Re: [BUID_FAILURE] regression from 2.6.24-git18 to 2.6.25-rc1-git1
 on section type conflict psmouse-base
References: <47B14D52.6050404@linux.vnet.ibm.com> <20080211235929.791f7afb.akpm@linux-foundation.org> <20080212093614.GF2959@cs181133002.pp.htv.fi> <47B16B16.60402@linux.vnet.ibm.com> <20080212095536.GG2959@cs181133002.pp.htv.fi>
In-Reply-To: <20080212095536.GG2959@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Feb 12, 2008 at 03:17:02PM +0530, Kamalesh Babulal wrote:
>> Adrian Bunk wrote:
>>> On Mon, Feb 11, 2008 at 11:59:29PM -0800, Andrew Morton wrote:
>>>> On Tue, 12 Feb 2008 13:10:02 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>>>
>>>>> This build failure is seen on the powerpc from the 2.6.24-git18 kernel and is still visible
>>>>> in the 2.6.25-rc1-git1.
>>>>>
>>>>> drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
>>>>> drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict
>>>>> make[3]: *** [drivers/input/mouse/psmouse-base.o] Error 1
>>>>> make[2]: *** [drivers/input/mouse] Error 2
>>>>> make[1]: *** [drivers/input] Error 2
>>>>>
>>>>> The patch http://lkml.org/lkml/2008/2/8/514 seems to have not taken into 2.6.25-rc1 and 
>>>>> 2.6.25-rc1-git(s). Is there any new patch i am missing out.
>>>> I have it queued up, along with quite a few other things, but for the next
>>>> couple of days I have logistical problems which are preventing me from
>>>> doing runtime testing.
>>> And this really isn't a regression.
>>>
>>> It seems Kamalesh has upgraded his gcc to 4.2 between trying 
>>> 2.6.24-git18 and trying 2.6.25-rc1-git1?
>>>
>>> cu
>>> Adrianhttp://sydgsa.ibm.com/gsa/sydgsa/projects/k/kernel.org/korg/
>>>
>> Hi Adrian,
>>
>> I am using the gcc version
>>
>> gcc (GCC) 4.2.3 20071014 (prerelease) (Debian 4.2.2-3)
>>
>> It has been the same gcc version from 2.6.24-git18 to 2.6.25-rc1-git{1,2).
>> This build failure is seen from 2.6.24-git18 and is still seen in 2.6.25-rc1-git{1,2}.
> 
> I misread what you meant with the word "from".
> 
> But my point is still that this is not a regression in the kernel but a 
> problem when using gcc 4.2 on powerpc (no matter whether the kernel or 
> gcc is wrong in this case).
> 
> Or am I wrong here and you are able to compile older powerpc kernels 
> with the same gcc and .config?
> 
>> Kamalesh Babulal,
> 
> cu
> Adrian
> 
Sorry for the term using "regression in the kernel", this seems not to be the regression from the 
kernel.I tried compiling older versions of kernels on the machine. I was able to reproduce the
same build failure with 2.6.23 and similar one with 2.6.22.

drivers/char/ipmi/ipmi_si_intf.c:1095: error: __param_hotmod causes a section type conflict
drivers/char/ipmi/ipmi_si_intf.c:1095: error: __param_hotmod causes a section type conflict

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
