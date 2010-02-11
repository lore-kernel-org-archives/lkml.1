Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab0BKKVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:21:38 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54163 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0BKKVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:21:37 -0500
MIME-Version: 1.0
In-Reply-To: <2375c9f91002050154m1d179ea7v91c8253b41fc63eb@mail.gmail.com>
References: <20100202120457.GA19605@omega> <20100203153101.GC4177@hack> 
	<20100203174947.GA13943@tango.0pointer.de> <2375c9f91002050154m1d179ea7v91c8253b41fc63eb@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 11 Feb 2010 11:21:19 +0100
Message-ID: <ac3eb2511002110221r61c7e5f4ieb21181197e6434@mail.gmail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for 
	child processes
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 10:54, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> Also, on a side note: code that checks if its parent process died most
>> likely should rewritten to use PR_DEATHSIG or something like that
>> anyway, so that it is notified about the parent dying instead of
>> polling for it manually.
>>
>
> I agree, but this is not a reason for you to break the compatiblity.

Any substantial comments instead?

Thanks,
Kay
