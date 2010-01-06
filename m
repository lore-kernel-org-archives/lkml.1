Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171Ab0AFDYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0AFDYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 22:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411Ab0AFDYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 22:24:30 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:33895 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0AFDYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 22:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Jmxad08mZDKlmtCjNZp+84rPOFzfh/eWw0whTZUeYMx3GNSVuWqwL7xK3n7puV8dRQ
         BZ/sWl/VCwWYtWQ0gjzwRHgXTCrhXXTDu4yObLAktnPBfAx/X2x7vpPJn1bAhHzh5AIh
         o2owR9tPi1jRilp+WV6kTyzGefUnTtV479vQQ=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a1001051128s272f9881q4f1418eba08f1478@mail.gmail.com>
References: <1254133004-24877-1-git-send-email-21cnbao@gmail.com> 
	<8bd0f97a0909291944q53a060buc7bcbb30c1240da7@mail.gmail.com> 
	<8bd0f97a1001051128s272f9881q4f1418eba08f1478@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 6 Jan 2010 11:18:37 +0800
Message-ID: <3c17e3571001051918q7a133a63p64e2b2465dd52a48@mail.gmail.com>
Subject: Re: [PATCH] Fix half-Y2K38 problem in timecompare_update while 
	calculating offset
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: akpm@linux-foundation.org, davem@davemloft.net, patrick.ohly@intel.com,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been merged into mainline:

timecompare: fix half-Y2K38 problem in timecompare_update while
calculating offset
author	Barry Song <21cnbao@gmail.com>	
	Wed, 16 Dec 2009 00:45:34 +0000 (16:45 -0800)
committer	Linus Torvalds <torvalds@linux-foundation.org>	
	Wed, 16 Dec 2009 15:19:57 +0000 (07:19 -0800)
commit	f065f41f48569122b5bcddbd1ba2354f7cc29fdc
tree	68606305bfb3aba16437017e0596ccae11e6f6db	tree | snapshot
parent	4365a5676fa3aa1d5ae6c90c22a0044f09ba584e	commit | diff
timecompare: fix half-Y2K38 problem in timecompare_update while
calculating offset

ktime will overflow from 03:14:07 UTC on Tuesday, 19 January 2038,
ktime_add() in timecompare_update() will overflow a half earlier.  As a
result, wrong offset will be gotten, then cause some strange problems.

Signed-off-by: Barry Song <21cnbao@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Patrick Ohly <patrick.ohly@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


On Wed, Jan 6, 2010 at 3:28 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Tue, Sep 29, 2009 at 21:44, Mike Frysinger wrote:
>> On Mon, Sep 28, 2009 at 06:16, Barry Song wrote:
>>> ktime will overflow from 03:14:07 UTC on Tuesday, 19 January 2038,
>>> ktime_add() in timecompare_update() will overflow a half earlier.
>>> As a result, wrong offset will be gotten, then cause some strange
>>> problems.
>>
>> Barry: you forgot to include your s-o-b tag ...
>
> you still need to post your s-o-b if we want this to go any further
> -mike
>
