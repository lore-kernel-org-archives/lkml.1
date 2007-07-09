Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbXGIEjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbXGIEjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXGIEjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:39:48 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:23204 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750750AbXGIEjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:39:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=bBlUP+ly+PYkfStrNUC07ZU8dbElNdlxVjeEp8mU1/s8vFbqiw2NCF0G4ctp+yusurD07dqFy3ajQVToXabASN8sc9g2ICUoNx41Aif7gmJh46Bol9Ub7KvuYz4oJrg+p13FIqmFUHDPXnCOxgZwNDYBHws0IKiuahXKFzqiqr0=  ;
X-YMail-OSG: vxPoX9MVM1mPMBXespjUqLBJDoIL2z5om9Pe_eDy0l1QTa7DDoa6dYiAICYYgZGuXo4fBogQDwWL97c7W_pHIq0sa_4KItnJ9bPnwGgbx.82m77rntQ-
Message-ID: <4691BC0F.8050909@yahoo.com.au>
Date: Mon, 09 Jul 2007 14:39:43 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
CC: Jeremy Maitin-Shepard <jbms@cmu.edu>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx> <4691B9A5.6060203@yahoo.com.au>
In-Reply-To: <4691B9A5.6060203@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Jeremy Maitin-Shepard wrote:
> 
>> Al Boldi <a1426z@gawab.com> writes:
>>
>>
>>> Pavel Machek wrote:
>>>
>>>> We are stuck with refrigerator for now, and at least for hibernation,
>>>> I don't see any feasible alternative.
>>
>>
>>
>>> Feasible alternative?
>>
>>
>>
>> I posted such an alternative to the list a short time ago: hibenrating
>> from a *new* kernel space/user space that is created by loading a new
>> kernel in a manner similar to what is done for kexec crashdumps.  Unlike
>> kexec crashdumps, however, it would not require reserving any memory at
>> boot, because the necessary memory (maybe 16MB or 64MB) can be freed
>> just before hibernating, and device drivers can be properly stopped so
>> that DMAs don't stomp over certain memory.
> 
> 
> This is the Morton method, isn't it? :) I remember it sounding like a
> very good idea when he brought it up, but I can't remember the details
> of why it was rejected or what the problems were.

Hmm, and it seems like I won't get to know without reliving what
looks like an epic flamewar starting.... here:

   http://thread.gmane.org/gmane.linux.kernel/374889

However from a quick look it seems like the only reason is the RAM
overhead of a reserve area. It seems unfortunate that it was
dismissed so quickly because of that problem (which could be
improved).

-- 
SUSE Labs, Novell Inc.
