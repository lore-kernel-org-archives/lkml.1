Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbYBUNh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbYBUNh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYBUNhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:37:17 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:54164 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYBUNhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:37:15 -0500
Message-ID: <47BD7E7F.2030603@allied-internet.ag>
Date: Thu, 21 Feb 2008 14:37:03 +0100
From: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: getting uninterruptible sleep processes after upgrade from 2.6.20.20
 to 2.6.24.2
References: <47B892B9.7060205@allied-internet.ag>	<alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>	<47B89DC6.4070906@allied-internet.ag> <20080217125407.5b76a052@laptopd505.fenrus.org> <47BD5B30.103@allied-internet.ag> <47BD7958.5080203@gmail.com>
In-Reply-To: <47BD7958.5080203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm using XFS. dmesg -s32000 does not help - no more output. In messages 
there is also no relevant output. Other than what I've posted here:
http://lkml.org/lkml/2008/2/21/76

Sorry but i cannot recompile the kernel on all machines again - another 
downtime is not possible at the moment.

Stefan

Jiri Slaby schrieb:
> Stefan Priebe - allied internet ag napsal(a):
>> Hello!
>>
>> I've done the (echo t > /proc/sysrq-trigger) now but i'm not able to get
>> the whole output via dmesg.
>>
>> Here is what i get:
>> # dmesg
>> 3.432124]  [<c0165a11>] do_select+0x390/0x46e
>> [272363.432226]  [<c0166107>] __pollwait+0x0/0xcf
>> [272363.432319]  [<c0115d90>] default_wake_function+0x0/0x8
> 
> dmesg ring buffer is too small to fit this in. Please repeat it once again
> with bigger ringbuffer (dmesg -s if you have this chosen in your kernel) or
> post /var/log/meassages output of all processes. I see only waiters in
> readdir, not seeing who could block them.
> 
> Which filesystem did you run du on?
> 
