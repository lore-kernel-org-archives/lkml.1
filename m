Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbYLWT7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYLWT7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 14:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYLWT7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 14:59:46 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:43288 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYLWT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 14:59:45 -0500
Message-ID: <4951432F.3050701@ct.jp.nec.com>
Date: Tue, 23 Dec 2008 11:59:43 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC -tip 2/4] x86: uaccess: introduce __{get|put}_user	exception
 handling framework
References: <49507534.5080401@ct.jp.nec.com> <495075B0.9020104@ct.jp.nec.com> <20081223143046.GD29151@elte.hu>
In-Reply-To: <20081223143046.GD29151@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Impact: introduce new framework
>>
>> Introduce exception handling framework.
>> __{get|put}_user_ex_try() begins exception block and
>> __{get|put}_user_ex_catch() ends block and if an exception occurred in this
>> block using __{get|put}_user_ex, direct jump to __{get|put}_user_ex_catch()
>> and err is set to specified value.
> 
> ha, this tickled ~12 year old memories: back then Linus came up with a 
> very, very similar scheme, for user-copy exception handling.
> 
> Such a scheme would be elegant, creates more compact code (we can use 
> conditional results directly in branch instructions instead of having to 
> export them into registers), and it makes sense syntactically, but it 
> doesnt work: GCC is free to reorder (or eliminate) basic blocks and these 
> labels can lose their relationship.
> 
> So this cannot be done via inline assembly right now, it needs some 
> compiler help. Sniff :)

thanks for the above explanation.
I felt it's very hard to understand GCC.

Thanks,
Hiroshi
