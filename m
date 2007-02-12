Return-Path: <linux-kernel-owner+w=401wt.eu-S964931AbXBLQcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931AbXBLQcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964940AbXBLQcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:32:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:53513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbXBLQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hQTG2Myi2El8lxPltip5A1oLOvIF9g2/YIL68d+viaiPNaQOMmz+Ia9S+T1R3fci7U50dyPq8enNdcZG04DOKJpY3eAIuY2BlmmFAOarK0AGg3IzuS7Ufi2zg5YwPz49Y7JnS3cF1FMDaoWS4Nrt0yO+ISO1PxpTYDBv1YIqa5o=
Message-ID: <45D0968F.8040103@gmail.com>
Date: Mon, 12 Feb 2007 17:32:15 +0100
From: dragoran <drago01@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: "Hesse, Christian" <mail@earthworm.de>
CC: James Ketrenos <jketreno@linux.intel.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [ANNOUNCE] d80211 based driver for Intel	PRO/Wireless
 3945ABG
References: <45CCE3CA.4050904@linux.intel.com>	<200702101424.00156.mail@earthworm.de> <200702101525.56820.mail@earthworm.de>
In-Reply-To: <200702101525.56820.mail@earthworm.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hesse, Christian wrote:
> On Saturday 10 February 2007 14:23, Hesse, Christian wrote:
>   
>> On Friday 09 February 2007 22:12, James Ketrenos wrote:
>>     
>>> We are pleased to announce the availability of a new driver for the
>>> Intel PRO/Wireless 3945ABG Network Connection adapter.
>>>       
>> Wow, great news on this rainy saturday! ;-)
>>
>> The driver works perfectly, I'm writing this mail via wireless link.
>> However there are two things to note:
>>
>> The driver generates two network devices. The second one is for promicious
>> mode? Is there any chance to disable the interface? ifrename renamed the
>> wrong one to wlan0 and I had to tell my system to use eth1 for the wireless
>> connection.
>>
>> Second problem is that I can't unload the module. I get the message "FATAL:
>> Module iwlwifi is in use." even if both interfaces are down.
>>     
>
> Oh, I forgot one note: "make patch_kernel" is terribly broken. Any chance to 
> get this fixed soon?
>   
>   
confirmed on my box it resulted in deleting all kernel modules.
(had to reinstall the kernel)
(make modules in /lib/modules/`uname -r`/build after make patch_kernel)
this was on fc6 x86_64


