Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXCLB2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXCLB2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 21:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXCLB2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 21:28:25 -0400
Received: from smtpout.mac.com ([17.250.248.178]:52728 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXCLB2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 21:28:24 -0400
In-Reply-To: <Pine.LNX.4.61.0703120015390.18623@yvahk01.tjqt.qr>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com> <Pine.LNX.4.61.0703112134180.16857@yvahk01.tjqt.qr> <200703111641.52066.dhazelton@enter.net> <14DE5DBD-4164-4CDF-9690-631514EB15EF@mac.com> <Pine.LNX.4.61.0703120015390.18623@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <333D1A52-915E-4D08-8E7E-7FBB23EC6357@mac.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Cong WANG <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Style Question
Date: Sun, 11 Mar 2007 21:27:53 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 11, 2007, at 19:16:59, Jan Engelhardt wrote:
> On Mar 11 2007 18:01, Kyle Moffett wrote:
>> On the other hand when __cplusplus is defined they define it to  
>> the "__null" builtin, which GCC uses to give type conversion  
>> errors for "int foo = NULL" but not "char *foo = NULL".  A "((void  
>> *)0)" definition gives C++ type errors for both due to the broken C 
>> ++ void pointer conversion problems.
>
> I think that the primary reason they use __null is so that you can
> actually do
>
> 	class foo *ptr = NULL;
>
> because
>
> 	class foo *ptr = (void *)0;
>
> would throw an error or at least a warning (implicit cast from void*
> to class foo*).

Isn't that what I said? :-D

Cheers,
Kyle Moffett

