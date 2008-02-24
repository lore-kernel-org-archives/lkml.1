Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbYBXKHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbYBXKHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 05:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYBXKG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:06:57 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:11870 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbYBXKG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:06:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ERAwS9n3ahSL7hJp94vbTGLqVSWwj017QGgG5yFpkZHGlxgBZ8FcU+sCpLrh4aYz3SfuTl+2LnJ8uJX0G5ykxICIl2/gs7vpBAY5cdfMOavzWTf05zkuIVguMrUM+rwufkHXX/kOTecmB7UkzmufqHX54uPbDJZ7+T6QD1Au6Z0=
Message-ID: <47C141B9.7050001@gmail.com>
Date: Sun, 24 Feb 2008 11:06:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
CC: Arjan van de Ven <arjan@infradead.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com,
       xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
Subject: Re: getting uninterruptible sleep processes after upgrade from 2.6.20.20
 to 2.6.24.2
References: <47B892B9.7060205@allied-internet.ag>	<alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>	<47B89DC6.4070906@allied-internet.ag> <20080217125407.5b76a052@laptopd505.fenrus.org> <47BD5B30.103@allied-internet.ag> <47BD7958.5080203@gmail.com> <47BD7E7F.2030603@allied-internet.ag>
In-Reply-To: <47BD7E7F.2030603@allied-internet.ag>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing xfs team

On 02/21/2008 02:37 PM, Stefan Priebe - allied internet ag wrote:
> Hello!
> 
> I'm using XFS. dmesg -s32000 does not help - no more output. In messages 
> there is also no relevant output. Other than what I've posted here:
> http://lkml.org/lkml/2008/2/21/76

http://lkml.org/lkml/2008/2/21/86

Some kind of borkage in readdir, probably either in xfs or vfs?

> Sorry but i cannot recompile the kernel on all machines again - another 
> downtime is not possible at the moment.
> 
> Stefan
> 
> Jiri Slaby schrieb:
>> Stefan Priebe - allied internet ag napsal(a):
>>> Hello!
>>>
>>> I've done the (echo t > /proc/sysrq-trigger) now but i'm not able to get
>>> the whole output via dmesg.
>>>
>>> Here is what i get:
>>> # dmesg
>>> 3.432124]  [<c0165a11>] do_select+0x390/0x46e
>>> [272363.432226]  [<c0166107>] __pollwait+0x0/0xcf
>>> [272363.432319]  [<c0115d90>] default_wake_function+0x0/0x8
>>
>> dmesg ring buffer is too small to fit this in. Please repeat it once 
>> again
>> with bigger ringbuffer (dmesg -s if you have this chosen in your 
>> kernel) or
>> post /var/log/meassages output of all processes. I see only waiters in
>> readdir, not seeing who could block them.
>>
>> Which filesystem did you run du on?
