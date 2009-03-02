Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbZCBSpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbZCBSpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZCBSpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:45:18 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:37626 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZCBSpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:45:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pSTJjPmzfDsdi1LIXjRfJefPZJpRghKiZh5cMXx9VqdbFJgoemvt11do1ZH8YU8j01
         Ur/3G8N1EAUtQrpKdXOGT1QoLKjHffvawkgWILqiuDo4pXgoybWW5t4j/l0hXLSX4jho
         oU3D3op3FmCprh7FvF/NDoGi9E+F0DRtKHg1Q=
Message-ID: <49AC28FF.1040102@gmail.com>
Date: Mon, 02 Mar 2009 19:44:15 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joao Correia <joaomiguelcorreia@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: some tc commands fail on 2.6.29-rc6-git5, works on 2.6.28.7
References: <a5d9929e0903011636w6bff1032y28ab58c0ff8c8052@mail.gmail.com> <20090301165729.8e08e1d7.akpm@linux-foundation.org>
In-Reply-To: <20090301165729.8e08e1d7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote, On 03/02/2009 01:57 AM:

> (cc netdev)
> 
> On Mon, 2 Mar 2009 00:36:03 +0000 Joao Correia <joaomiguelcorreia@gmail.com> wrote:
> 
>> Hello all
>>
>> On a Fedora 9 box, with a 2.6.29-rc6-git5 compiled with the same
>> .config as the previously running 2.6.28.7, i get:
>>
>> [root@duron ~]# /sbin/tc qdisc add dev eth2 handle ffff: ingress
>> [root@duron ~]# /sbin/tc filter add dev eth2 parent ffff: protocol ip
>> prio 50 u32 match ip src 0.0.0.0/0 police rate 30320kbit burst 500k
>> drop flowid :1
>> RTNETLINK answers: Invalid argument
>> We have an error talking to the kernel
>> [root@duron ~]# uname -a
>> Linux duron 2.6.29-rc6-git5 #3 SMP Sun Mar 1 00:02:56 WET 2009 i686
>> athlon i386 GNU/Linux
>> [root@duron ~]#
>>
>> There is no information regarding this event on dmesg or /var/log/messages.
>> eth2 exists and is working properly, under 2.6.28.7 it works (without
>> complaints).
>>
>> Please advise on what steps I may take to provide more information. I have
>> both kernel sources and availability to apply patches/recompile as needed.
 

Hi,

I've just repeated your commands (with eth0) on the current Linus' tree
and it works OK. Check your .config and "modules_install" again, and if
no result send gzipped .config and show "lsmod" and "tc -V" output after
these commands above.

Cheers,
Jarek P.
