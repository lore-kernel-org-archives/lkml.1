Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbYFUAha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbYFUAha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 20:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYFUAhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 20:37:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbYFUAhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 20:37:19 -0400
Date: Fri, 20 Jun 2008 20:37:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080620.154716.75920403.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806201925400.6353@engineering.redhat.com>
References: <Pine.LNX.4.64.0806201819430.25997@engineering.redhat.com>
 <20080620.152847.169209890.davem@davemloft.net>
 <Pine.LNX.4.64.0806201833200.25997@engineering.redhat.com>
 <20080620.154716.75920403.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Fri, 20 Jun 2008 18:36:09 -0400 (EDT)
>
>> On Fri, 20 Jun 2008, David Miller wrote:
>>
>>> Yes for debugging and other things it has to stay.
>>
>> If you want it to stay, then it doesn't make sense to make functions
>> tail-call-friendly --- because it should not crash with or without
>> debugging.
>
> On the contrary, of course it makes sense to do so.
>
> When debugging is disabled, the kernel will run faster.
>
> We have to fix the stack usage in either case, but from a
> performance standpoint when debugging is disabled the
> tail-call friendly layout is still highly desirable.

I agree, but performance is different problem than stack overflows.

I put all the patches for this overflow problem here:
http://people.redhat.com/mpatocka/patches/kernel-stack-overflow

Mikulas
