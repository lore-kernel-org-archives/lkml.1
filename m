Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756056AbYLPWVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYLPWVn (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYLPWVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:21:31 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:30391 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYLPWVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:21:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LrAyXQ9EHeKqZJv89/+SrrQOtxd2NxDd+EdBCZHaUu4mA1u1tIYP7yYaqouVUJBB5g
         AkDCHktq49yrtsoxbYDVEvfxiNQ7KKqSygLtw0kyyubMpvJN63DS37FDsoD6VluI+cGN
         h2kCeYRAnpw/bCRVuIf73Xit1gIv0p2yLv0iw=
Message-ID: <f19298770812161421r77a10575ia956e59a52d7efb2@mail.gmail.com>
Date: Wed, 17 Dec 2008 01:21:29 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux-next: Tree for December 11
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20081216210834.GM14787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211200459.14d18d7a.sfr@canb.auug.org.au>
	 <f19298770812110440s7e3781eex4a16b961ad6847b2@mail.gmail.com>
	 <f19298770812140634j434bf6a6gd883688f00dac45e@mail.gmail.com>
	 <20081216210834.GM14787@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 00:08, Ingo Molnar <mingo@elte.hu> wrote:

>>
>> The warning can also be reproduced in qemu, so it was easy to bisect.
>>
>> commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
>> Author: Nick Piggin <nickpiggin@yahoo.com.au>
>> Date:   Tue Sep 30 20:50:27 2008 +1000
>>
>>     sched: improve preempt debugging
>>
>>     This patch helped me out with a problem I recently had....
>>
>>     Basically, when the kernel lock is held, then preempt_count
>> underflow does not
>>     get detected until it is released which may be a long time (and arbitrarily,
>>     eg at different points it may be rescheduled). If the bkl is released at
>>     schedule, the resulting output is actually fairly cryptic...
>>
>>     With any other lock that elevates preempt_count, it is illegal to schedule
>>     under it (which would get found pretty quickly). bkl allows scheduling with
>>     preempt_count elevated, which makes underflows hard to debug.
>>
>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>> I understand that not this particular commit is buggy, but at least
>> I've got someone to add to the CC. ;)
>>
>> Also the author's e-mail looks suspicious.
>
> Suspicious in what way?

Does not appear in signed-off-by.

>
>        Ingo
>
