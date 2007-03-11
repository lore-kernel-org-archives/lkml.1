Return-Path: <linux-kernel-owner+w=401wt.eu-S932875AbXCKWCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbXCKWCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbXCKWCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:02:10 -0400
Received: from smtpout.mac.com ([17.250.248.178]:58559 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbXCKWCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:02:09 -0400
In-Reply-To: <200703111641.52066.dhazelton@enter.net>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com> <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr> <200703111641.52066.dhazelton@enter.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <14DE5DBD-4164-4CDF-9690-631514EB15EF@mac.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Cong WANG <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Style Question
Date: Sun, 11 Mar 2007 18:01:38 -0400
To: Daniel Hazelton <dhazelton@enter.net>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 11, 2007, at 16:41:51, Daniel Hazelton wrote:
> On Sunday 11 March 2007 16:35:50 Jan Engelhardt wrote:
>> On Mar 11 2007 22:15, Cong WANG wrote:
>>> So can I say using NULL is better than 0 in kernel?
>>
>> On what basis? Do you even know what NULL is defined as in (C, not  
>> C++) userspace? Think about it.
>
> IIRC, the glibc and GCC headers define NULL as (void*)0  :)

On the other hand when __cplusplus is defined they define it to the  
"__null" builtin, which GCC uses to give type conversion errors for  
"int foo = NULL" but not "char *foo = NULL".  A "((void *)0)"  
definition gives C++ type errors for both due to the broken C++ void  
pointer conversion problems.

Cheers,
Kyle Moffett

