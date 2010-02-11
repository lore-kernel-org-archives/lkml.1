Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0BKO5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:57:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41444 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0BKO5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:57:31 -0500
Message-ID: <4B741ABB.2000600@zytor.com>
Date: Thu, 11 Feb 2010 06:56:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Carlos R. Mafra" <crmafra2@gmail.com>
CC: Alexander Lam <lambchop468@gmail.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: mtrr cleanup not doing anything on 2.6.33-rc7
References: <dfb03c971002101202i37f4a243jc6bfb44bc853cb5d@mail.gmail.com> <dfb03c971002101748i39d7de0bw83634c40f058de0f@mail.gmail.com> <20100211101013.GA4892@Pilar.aei.mpg.de>
In-Reply-To: <20100211101013.GA4892@Pilar.aei.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 02:10 AM, Carlos R. Mafra wrote:
> [Add people in that commit to Cc: list, just in case]
> 
> On Mi 10.Feb'10 at 20:48:49 -0500, Alexander Lam wrote:
>> On Wed, Feb 10, 2010 at 3:02 PM, Alexander Lam <lambchop468@gmail.com> wrote:
>>>
>>> My kernel config has the following:
>>> CONFIG_MTRR=y
>>> CONFIG_MTRR_SANITIZER=y
>>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
>>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>>>
>>> With previous kernels, dmesg would show that the sanitizer was indeed
>>> cleaning up the mtrrs [1]
>>>
>>> but now, with 2.6.33-rc7 there is no indication that this is occuring,
>>
>> For those who run across this later,
>>
>> Found out that commit 508d85c2c6bc8cba53d2a54d9a306ad64a0a80bf,
>>    x86: When cleaning MTRRs, do not fold WP into UC
>>
>> causes mtrr cleanup not to run on my machine.
>>
>> Probably not worth fixing because the i915 error message is harmless.
>> --

You're not stating what your MTRR setup looks like, and hence if there
is anything to clean up.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

