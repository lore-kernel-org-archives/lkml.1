Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYBYS1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYBYS1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYBYS1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:27:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbYBYS1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:27:10 -0500
Message-ID: <47C306A1.2040909@zytor.com>
Date: Mon, 25 Feb 2008 10:19:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EFI_PAGE_SHIFT fix
References: <1203923917.4707.58.camel@caritas-dev.intel.com> <20080225074059.GI11327@elte.hu>
In-Reply-To: <20080225074059.GI11327@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
>> Make x86 EFI code works when EFI_PAGE_SHIFT != PAGE_SHIFT. The 
>> memrage_efi_to_native() provided in this patch can be used on other 
>> EFI platform such as IA64 too.
>>
>> This patch has been tested on Intel x86_64 platform with EFI 64/32 
>> firmware.
> 
> this is mostly cosmetic, isnt it - because currently nobody expects 
> EFI_PAGE_SHIFT and PAGE_SHIFT to ever change on x86, right? I've queued 
> up your patch for 2.6.26, ok?
> 

There keeps being a lot of talk about a larger x86 pagesize, either 
involving future hardware support or via page clustering in the kernel.

Going beyond a 48-bit address space (in long mode) may mean increasing 
the page size.

	-hpa
