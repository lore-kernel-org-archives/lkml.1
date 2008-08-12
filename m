Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYHLGuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYHLGuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYHLGuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:50:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59257 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYHLGuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:50:22 -0400
Message-ID: <48A131DC.9030702@cs.helsinki.fi>
Date: Tue, 12 Aug 2008 09:46:52 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, cl@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       rostedt@goodmis.org, tglx@linutronix.de
Subject: Re: [PATCH 5/5] kmemtrace: SLOB hooks.
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>	 <1218388447-5578-6-git-send-email-eduard.munteanu@linux360.ro>	 <84144f020808101048l7d62c133paf320c48748fe514@mail.gmail.com> <1218410301.7576.310.camel@calx>
In-Reply-To: <1218410301.7576.310.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Sun, 2008-08-10 at 20:48 +0300, Pekka Enberg wrote:
>> On Sun, Aug 10, 2008 at 8:14 PM, Eduard - Gabriel Munteanu
>> <eduard.munteanu@linux360.ro> wrote:
>>> This adds hooks for the SLOB allocator, to allow tracing with kmemtrace.
>>>
>>> We also convert some inline functions to __always_inline to make sure
>>> _RET_IP_, which expands to __builtin_return_address(0), always works
>>> as expected.
>>>
>>> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
>> I think Matt acked this already but as you dropped the tags, I'll ask
>> once more before I merge this.
> 
> Yeah, that's fine.
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

Applied, thanks!
