Return-Path: <linux-kernel-owner+w=401wt.eu-S1751333Ab0AHFSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab0AHFSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112Ab0AHFSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:18:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:36273 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0AHFSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:18:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="230527956"
From: "Zheng, Shaohui" <shaohui.zheng@intel.com>
To: "H. Peter Anvin" <hpa@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "x86@kernel.org" <x86@kernel.org>
Date: Fri, 8 Jan 2010 13:18:01 +0800
Subject: RE: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel(v1)
Thread-Topic: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel(v1)
Thread-Index: AcqQH8/8Vvg56cLKQF+5b8PvSUFC3wAAP8aQ
Message-ID: <DA586906BA1FFC4384FCFD6429ECE86031560C27@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
 <4B46BC6F.5060607@kernel.org>
In-Reply-To: <4B46BC6F.5060607@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o085In16002719

Thanks Peter, my testing shows that there are many issues on 32-bit kernel for memory hot-add, there are still more works to do for 32-bit kernels(more than 2 patches). Memory hot-add is much more important on 64-bit kernel, I think that we can fix the bug on 64-bit kernel first. 32-kernel hotplug is the working in next step.

Thanks & Regards,
Shaohui


-----Original Message-----
From: H. Peter Anvin [mailto:hpa@kernel.org] 
Sent: Friday, January 08, 2010 1:03 PM
To: Zheng, Shaohui
Cc: linux-mm@kvack.org; akpm@linux-foundation.org; linux-kernel@vger.kernel.org; ak@linux.intel.com; y-goto@jp.fujitsu.com; Dave Hansen; Wu, Fengguang; x86@kernel.org
Subject: Re: [PATCH - resend] Memory-Hotplug: Fix the bug on interface /dev/mem for 64-bit kernel(v1)

On 01/07/2010 07:32 PM, Zheng, Shaohui wrote:
> Resend the patch to the mailing-list, the original patch URL is 
> http://patchwork.kernel.org/patch/69075/, it is not accepted without comments,
> sent it again to review.
> 
> Memory-Hotplug: Fix the bug on interface /dev/mem for 64-bit kernel
> 
> The new added memory can not be access by interface /dev/mem, because we do not
>  update the variable high_memory. This patch add a new e820 entry in e820 table,
>  and update max_pfn, max_low_pfn and high_memory.
> 
> We add a function update_pfn in file arch/x86/mm/init.c to udpate these
>  varibles. Memory hotplug does not make sense on 32-bit kernel, so we did not
>  concern it in this function.
> 

Memory hotplug makes sense on 32-bit kernels, at least in virtual
environments.

	-hpa
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
