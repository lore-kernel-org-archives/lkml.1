Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbZEMAhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbZEMAhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZEMAgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:36:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:31657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbZEMAgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qYy7f3oeknOiTGg0plELFS6uUmbMVfQPkQcyc4zXWCG0xmaMQlhsIMyBFe23FeAIty
         zWAPr8wqMaEvLb/Xox68A02EL9tueL0iYP+nIa5TiDZBtiyHTro5RvSqaR+dqO8FbDj3
         jVWm3BldlHE/LRaS806Y88RSnDV1IMRUReDx4=
MIME-Version: 1.0
In-Reply-To: <20090512155842.GE30014@hack>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	 <20090512154456.GC6255@nowhere> <20090512155842.GE30014@hack>
Date: Wed, 13 May 2009 08:36:05 +0800
Message-ID: <d82e647a0905121736n7a73e166h61a899d8e4a63d0a@mail.gmail.com>
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
From: Ming Lei <tom.leiming@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/12 Américo Wang <xiyou.wangcong@gmail.com>:
> On Tue, May 12, 2009 at 05:44:58PM +0200, Frederic Weisbecker wrote:
>>On Tue, May 12, 2009 at 11:13:42PM +0800, tom.leiming@gmail.com wrote:
>>> From: Ming Lei <tom.leiming@gmail.com>
>>>
>>> -    if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
>>> +    sync_run = !async_enabled || !entry || \
>>> +                    atomic_read(&entry_count) > MAX_WORK;
>
>
> And also this one...
>
> Hey, Ming, none of these are macros... You don't need to add backslash to
> join two lines, C compilers can recognize.

OK, I'll fix it in next version.
Thanks!

>
> --
> Live like a child, think like the god.
>
>



-- 
Lei Ming
