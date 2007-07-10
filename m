Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbXGJNDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbXGJNDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXGJNDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:03:33 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:44367 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbXGJNDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:03:32 -0400
Message-ID: <46938391.5030306@openvz.org>
Date: Tue, 10 Jul 2007 17:03:13 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@free.fr>
CC: Cedric Le Goater <clg@fr.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Kirill Korotaev <dev@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/16] Pid namespaces
References: <468DF6F7.1010906@openvz.org>	<1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>	<46929540.2090405@fr.ibm.com> <46936DC8.3050602@openvz.org> <469375F4.1010608@free.fr>
In-Reply-To: <469375F4.1010608@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano wrote:
> Pavel Emelianov wrote:
>> Cedric Le Goater wrote:
>>> Badari Pulavarty wrote:
>>>> On Fri, 2007-07-06 at 12:01 +0400, Pavel Emelianov wrote:
>>>>> This is "submition for inclusion" of hierarchical, not kconfig
>>>>> configurable, zero overheaded ;) pid namespaces.
>>>> Not able to boot my ppc64 machine with the patchset :(
>>> I can't boot either on a x86_64 but I don't even have logs to send :(
> 
> Did you tryed to append at the kernel command  line the parameter:
> 
>     earlyprintk=serial,ttyS0,keep

I have already faced the problem, thanks :)

The bad-guy is CONFIG_DMAR. I'll talk to intel developers about this :)

And a couple of patches to fix proc (I'll send them in a moment). i386 works 
without is and all the others crash. Kirill explained me why. It looks like 
a big problem for i386. He told, that during the boot first 32MiBs of memory
are mapped and thus all NULL pointer dereferences succeed. Is it good?

Thanks,
Pavel

>>
>> Neither can I. And I cannot boot clean 2.6.22-rc6-mm1 either :(
>> Does someone already know what the reason is?
>>
>>> C.
>>>
>>
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.linux-foundation.org
>> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

