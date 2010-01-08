Return-Path: <linux-kernel-owner+w=401wt.eu-S1750915Ab0AHFKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915Ab0AHFKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799Ab0AHFKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:10:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0AHFKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:10:33 -0500
Message-ID: <4B46BC6F.5060607@kernel.org>
Date: Thu, 07 Jan 2010 21:02:39 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Zheng, Shaohui" <shaohui.zheng@intel.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH - resend] Memory-Hotplug: Fix the bug on interface /dev/mem
 for 64-bit kernel(v1)
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
In-Reply-To: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
