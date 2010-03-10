Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab0CKABF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 19:01:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:34878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab0CKABB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:01:01 -0500
Message-ID: <4B98326A.1020905@kernel.org>
Date: Wed, 10 Mar 2010 15:59:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 5/6] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
References: <1268256267-3769-1-git-send-email-yinghai@kernel.org> <1268256267-3769-6-git-send-email-yinghai@kernel.org> <20100310234620.GA3897@brick.ozlabs.ibm.com>
In-Reply-To: <20100310234620.GA3897@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 03:46 PM, Paul Mackerras wrote:
> On Wed, Mar 10, 2010 at 01:24:26PM -0800, Yinghai Lu wrote:
> 
>> move it to kernel/fw_memmap.c from arch/x86/kernel/e820.c
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/include/asm/e820.h |  130 -----
>>  arch/x86/kernel/e820.c      | 1142 --------------------------------------------
>>  include/linux/bootmem.h     |    2 
>>  include/linux/fw_memmap.h   |  114 ++++
>>  kernel/Makefile             |    2 
>>  kernel/fw_memmap.c          | 1134 +++++++++++++++++++++++++++++++++++++++++++
> 
> Yuck.  So you think we should use > 1100 lines of fw_memmap.c code
> instead of the 541 lines of lib/lmb.c?  Why exactly would that be
> better?
> 

even worse

you should count
early_res + fw_memmap 

YH
