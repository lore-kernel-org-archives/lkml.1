Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZA3PVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZA3PVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbZA3PUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:20:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:35079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbZA3PUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:20:54 -0500
Message-ID: <49831ACE.1020300@kernel.org>
Date: Sat, 31 Jan 2009 00:20:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: UV fix uv_flush_send_and_wait
References: <E1LSeXm-0007ck-9j@eag09.americas.sgi.com> <20090130150257.GA27549@elte.hu>
In-Reply-To: <20090130150257.GA27549@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 30 Jan 2009 15:20:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Cliff Wickman <cpw@sgi.com> wrote:
> 
>> From: Cliff Wickman <cpw@sgi.com>
>>
>> uv_flush_send_and_wait() should return a pointer if the broadcast
>> remote tlb shootdown requests fail. That causes the conventional IPI
>> method of shootdown to be used.
>>
>> Diffed against 2.6.29-rc2
>>   (Ingo's tree)
>>
>> Signed-off-by: Cliff Wickman <cpw@sgi.com>
>> ---
>>  arch/x86/kernel/tlb_uv.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Applied to tip/x86/urgnet, thanks Cliff!

Ingo, this patch shouldn't go into x86/urgent.  This patch is to fix a
bug introduced by a patch in the percpu branch and not applicable to
x86/urgent.

Thanks.

-- 
tejun
