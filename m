Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbZGCHCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbZGCHCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZGCHCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:02:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:40445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZGCHCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:02:24 -0400
Message-ID: <4A4DACB4.5040207@kernel.org>
Date: Fri, 03 Jul 2009 00:01:08 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, mikpe@it.uu.se, alex.shi@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: add boundary check for 32bit res before
 expand e820 resource to alignment
References: <tip-4b05c392955458757790414bd7ba4280e1a515b0@git.kernel.org> <20090703065632.GB32687@elte.hu>
In-Reply-To: <20090703065632.GB32687@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Commit-ID:  4b05c392955458757790414bd7ba4280e1a515b0
>> Gitweb:     http://git.kernel.org/tip/4b05c392955458757790414bd7ba4280e1a515b0
>> Author:     Yinghai Lu <yinghai@kernel.org>
>> AuthorDate: Thu, 2 Jul 2009 11:10:56 -0700
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Thu, 2 Jul 2009 11:53:15 -0700
>>
>> x86: add boundary check for 32bit res before expand e820 resource to alignment
>>
>> Avoid incorrect address arithmetic, ascerbated by previous improper
>> definition of the round_up() macro.
>>
>> fix hang with HIGHMEM_64G and 32bit resource.
>> according to hpa and Linus, use (resource_size_t)-1 to fend off big ranges.
>> analyized by hpa
>>
>> Alex found:
>> for i386 machine the specjbb2005 still can not run with hugepage
>>
>> -v2: it also fix hugepage problem
>>
>> Reported-and-tested-by: Mikael Pettersson <mikpe@it.uu.se>
>> Reported-and-Tested-by: Alex Shi <alex.shi@intel.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> 
> Peter, Yinghi - i zapped this and the other e820 patch from 
> x86/urgent as Linus already applied slightly different versions 
> upstream:
> 
> 7c5371c: x86: add boundary check for 32bit res before expand e820 resource to alignment

the same, only comments is different.

> 4364467: x86: fix power-of-2 round_up/round_down macros
more safe.

do we need to move it include/linux/kernel.h ?

YH


