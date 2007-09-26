Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXIZXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXIZXrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbXIZXrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:47:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20666 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbXIZXrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:47:11 -0400
Message-ID: <46FAEF76.9050202@oracle.com>
Date: Wed, 26 Sep 2007 16:47:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Jonathan Campbell <jon@nerdgrounds.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel 2.6.22.7
References: <46F77A85.6020202@nerdgrounds.com>	<20070924104940.50a52cf3.randy.dunlap@oracle.com>	<46FAA808.90004@nerdgrounds.com> <20070926162059.e6eb5e93.randy.dunlap@oracle.com> <46FAEE97.7090902@nerdgrounds.com>
In-Reply-To: <46FAEE97.7090902@nerdgrounds.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Campbell wrote:
> Sorry about that. That's why I always send as attachments.
> Do you have similar problems when using Mozilla Thunderbird?

tbird works when following the instructions at
http://mbligh.org/linuxdocs/Email/Clients/Thunderbird
or (simpler) use an External Editor plugin.


> And have you checked System.map to verify the DMI functions aren't there?

Nope.  I expect(ed) you to do that, i.e., make sure that the patch
does that the description says that it does.


>> On Wed, 26 Sep 2007 11:42:16 -0700 Jonathan Campbell wrote:
>>
>>   
>>> Here is the DMI patch again, written against linux-2.6.23-rc8,
>>> with some of the #ifdef CONFIG_DMI's removed and moved
>>> to include/linux/dmi.h. Putting them there in the way I've done
>>> ensures that you don't have to put #ifdef CONFIG_DMI
>>> around each dmi_check_machine() and that you don't
>>> have to apply little patches to so many device drivers.
>>>     
>>
>> Damaged as the patch is, I was able to apply it by using
>> 'patch -l' (ignore whitespace) + some fuzz.  Not something that
>> Linus or Andrew would or should do.
>>
>> I built and booted the kernel, it's running fine (x86_32 notebook).

-- 
~Randy
Phaedrus says that Quality is about caring.
