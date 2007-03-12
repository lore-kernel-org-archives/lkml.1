Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbXCLBnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbXCLBnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 21:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932654AbXCLBnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 21:43:53 -0400
Received: from smtpout.mac.com ([17.250.248.186]:54976 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbXCLBnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 21:43:53 -0400
In-Reply-To: <Pine.LNX.4.61.0703120229030.18623@yvahk01.tjqt.qr>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com> <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr> <200703111641.52066.dhazelton@enter.net> <14DE5DBD-4164-4CDF-9690-631514EB15EF@mac.com> <Pine.LNX.4.61.0703120015390.18623@yvahk01.tjqt.qr> <333D1A52-915E-4D08-8E7E-7FBB23EC6357@mac.com> <Pine.LNX.4.61.0703120229030.18623@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6A4569B5-FC04-49CA-87F5-D0595A0F41FA@mac.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Cong WANG <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Style Question
Date: Sun, 11 Mar 2007 21:43:25 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 11, 2007, at 21:32:00, Jan Engelhardt wrote:
> On Mar 11 2007 21:27, Kyle Moffett wrote:
>> On Mar 11, 2007, at 19:16:59, Jan Engelhardt wrote:
>>> On Mar 11 2007 18:01, Kyle Moffett wrote:
>>>> On the other hand when __cplusplus is defined they define it to the
>>>> "__null" builtin, which GCC uses to give type conversion errors for
>>>> "int foo = NULL" but not "char *foo = NULL".
>
>>> I think that the primary reason they use __null is so that you can
>>> actually do[...]
>>
>> Isn't that what I said? :-D
>
> Ya. Though I was picking at
>
>> "__null" builtin, which GCC uses to give type conversion errors  
>> for "int foo = NULL"
>
> since C's (void *)0 would also barf when being assigned to int.  So  
> it's not a genuine __null feature ;-)

You chopped my sentence in half! :-D  What I *really* said was:
> ...give type conversion errors for 'int foo = NULL' but not 'char  
> *foo = NULL'.

The pseudo-standard "#define NULL (0)" that the C++ standards ask for  
does *NOT* give an error for "int foo = NULL;", and in C++ the C- 
standard "#define NULL ((void *)0)" *does* give an error for "char  
*foo = NULL;"  Ergo I think I was correct when I said "GCC uses  
[__null] to give type conversion errors for <the-first> but not <the- 
second>"

Cheers,
Kyle Moffett
