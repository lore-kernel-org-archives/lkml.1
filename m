Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYAUTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYAUTOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 14:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYAUTOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 14:14:04 -0500
Received: from lucidpixels.com ([75.144.35.66]:47024 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYAUTOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 14:14:03 -0500
Date: Mon, 21 Jan 2008 14:14:02 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Yinghai Lu <Yinghai.Lu@sun.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
In-Reply-To: <200801210830.22322.jesse.barnes@intel.com>
Message-ID: <alpine.DEB.0.999999.0801211413350.10066@p34.internal.lan>
References: <200801192045.17291.yinghai.lu@sun.com> <200801202255.58642.yinghai.lu@sun.com> <200801202256.48365.yinghai.lu@sun.com> <200801210830.22322.jesse.barnes@intel.com>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Jan 2008, Jesse Barnes wrote:

> On Sunday, January 20, 2008 10:56 pm Yinghai Lu wrote:
>> [PATCH] x86_32: trim memory by updating e820 v2
>>
>> when mtrr is not covering all e820 table, need to trim the ram, need to
>> update e820
>>
>> reuse some code for x86_64
>>
>> here need to add early_identify_cpu for x86_32, and move mtrr_bp_init early
>>
>> compiled test only, need someone test it
>
> I like this approach too.  So as long as the E820 modification method works
> (i.e. we have some testers, maybe Justin can give it a try), you can add
>
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
>
> or
>
> Acked-by:  Jesse Barnes <jesse.barnes@intel.com>
>
> as appropriate too.
>
> Thanks,
> Jesse
>

Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
                          ^^

I run x86_64 btw-- if there is a kernel.patch for x86_64 please let me 
know and I can test, thanks.

Justin.
