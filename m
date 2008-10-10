Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYJJESf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYJJESf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 00:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYJJES0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 00:18:26 -0400
Received: from gw.goop.org ([64.81.55.164]:37803 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYJJES0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 00:18:26 -0400
Message-ID: <48EED78F.9040608@goop.org>
Date: Thu, 09 Oct 2008 21:18:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #6, misc
References: <20081010000817.GA9266@elte.hu> <200810101443.48237.nickpiggin@yahoo.com.au>
In-Reply-To: <200810101443.48237.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 10 October 2008 11:08, Ingo Molnar wrote:
>
>   
>> out-of-topic modifications in x86-v28-for-linus-phase6:
>> -------------------------------------------------------
>> include/linux/kernel.h             # d974ae3: generic, memparse(): constify
>> arg include/linux/mm.h                 # f7d0b92: mm: define
>> USE_SPLIT_PTLOCKS rath # 59ea746: MM: virtual address debug
>> include/linux/mm_types.h           # f7d0b92: mm: define USE_SPLIT_PTLOCKS
>> rath include/linux/mmdebug.h            # 7aa413d: x86, MM: virtual address
>> debug, c # 59ea746: MM: virtual address debug lib/cmdline.c                
>>      # d974ae3: generic, memparse(): constify arg mm/vmalloc.c             
>>          # 7aa413d: x86, MM: virtual address debug, c # 59ea746: MM:
>> virtual address debug
>>     
>
>
> How come these kinds of things go into the x86 tree? Can't they
> be sent to other maintainer first (probably Andrew, in the case
> of random -mm stuff).
>
> OK, it's pretty trivial stuff, but just on principle I can't see
> an advantage, and only disadvantages to doing this (and also I
> see the vmalloc change clashed with the vmalloc rewrite in -mm).

The memparse and split ptlocks changes went past Andrew.  They ended up 
in Ingo's tree because 1) they're pretty trivial, and 2) there's 
x86-specific stuff which depends on them.  Don't know about the vmalloc 
change.

    J
