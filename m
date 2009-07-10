Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbZGJIfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbZGJIfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbZGJIfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:35:24 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:44041 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZGJIfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:35:23 -0400
Message-ID: <4A56FD45.6060304@in.ibm.com>
Date: Fri, 10 Jul 2009 14:05:17 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: Badness at drivers/char/tty_ldisc.c:210 during shutdown
References: <4A3A2D2B.7070704@in.ibm.com>	<4A3F281F.9000408@in.ibm.com> <1245655421.4400.78.camel@concordia> <20090622095245.38edafdd@lxorguk.ukuu.org.uk>
In-Reply-To: <20090622095245.38edafdd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> [c00000003cf6ba70] [c00000000040a3d0] .tty_ldisc_put+0xa4/0xf4 (unreliable)
>>> [c00000003cf6bb10] [c00000000040a7c8] .tty_ldisc_reinit+0x38/0x80
>>> [c00000003cf6bba0] [c00000000040b1d8] .tty_ldisc_hangup+0x190/0x260
>>> [c00000003cf6bc40] [c000000000401090] .do_tty_hangup+0x188/0x4c0
>>> [c00000003cf6bd20] [c000000000401440] .tty_vhangup_self+0x34/0x54
>>> [c00000003cf6bdb0] [c00000000019236c] .sys_vhangup+0x38/0x58
>>> [c00000003cf6be30] [c000000000008534] syscall_exit+0x0/0x40
>>> Instruction dump:
>>> 912b0088 4bcd17bd 60000000 e87e8008 7f44d378 481c04fd 60000000 801b0008 
>>> 7c09fe70 7d200278 7c004850 54000ffe <0b000000> 7f63db78 4bd7c98d 60000000 
>>>       
>> Ah right, so this has check has just gone in, and the code in question
>> has been rewritten somewhat just recently.
>>     
>
> The check is to catch any cases where a line discipline is being freed up
> but has a refcount that is non zero. I think I know what is going on here.
>   
This issue can be recreated with 2.6.31-rc2-git4 kernel
(34f25476ace556263784ea2f8173e22b25557a13).

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

