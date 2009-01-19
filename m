Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZASNoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZASNoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZASNns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:43:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:60689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZASNns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:43:48 -0500
Message-ID: <4974838F.4020606@kernel.org>
Date: Mon, 19 Jan 2009 22:43:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET x86:core/percpu] percpu: move PDA fields to percpu
References: <1232296759-2253-1-git-send-email-tj@kernel.org> <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com> <4973E938.4010408@kernel.org> <20090119111932.GC18996@elte.hu> <20090119113530.GA13185@elte.hu>
In-Reply-To: <20090119113530.GA13185@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 19 Jan 2009 13:43:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Tejun Heo <tj@kernel.org> wrote:
>>
>>> Hello, Ingo, Brian.
>>>
>>> Brian Gerst wrote:
>>>> Here are the remaining patches rebased on top of these.
>>> Ingo, here's git tree for kill-pda patches.
>>>
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
>>>
>>> I dropped early irq_stack_ptr relocation from 0004.  I'll post updated 
>>> patch as reply to the original patch.  If you think it's still 
>>> necessary, please feel free to discuss it.  I also added a patch to kill 
>>> PERCPU_VADDR_PREALLOC().  Will post the patch as a reply to 0005.
>> Pulled these commit into tip/core/percpu:
> 
> hm, actually - the stackprotector impact is getting quite nasty. So i 
> think we are better off by merging the stackprotector fixes into 
> core/percpu, and then rebasing these commits on top of that. I pushed out 
> a new core/percpu branch with that done - and stackprotector works in that 
> lineup.
> 
> Would you mind to redo these commits on top of that? I tried the conflict 
> resolution but it looks quite complex and non-obvious - it would be 
> cleaner to have it this way.

Sure, will rebase and repost.

Thanks.

-- 
tejun
