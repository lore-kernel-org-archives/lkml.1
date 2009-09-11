Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZIKRfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZIKRfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 13:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZIKRfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 13:35:18 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:35641 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZIKRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 13:35:17 -0400
Message-ID: <4AAA8A56.3040707@codemonkey.ws>
Date: Fri, 11 Sep 2009 12:35:18 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
CC: Alan Cox <alan@linux.intel.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090911163806.GB25535@amit-x200.redhat.com> <4AAA8838.1080106@codemonkey.ws> <20090911173307.GB27046@amit-x200.redhat.com>
In-Reply-To: <20090911173307.GB27046@amit-x200.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> On (Fri) Sep 11 2009 [12:26:16], Anthony Liguori wrote:
>   
>> Amit Shah wrote:
>>     
>>> Right; there was some discussion about this. A few alternatives were
>>> suggested like
>>>
>>> - udev scripts to create symlinks from ports to function, like:
>>>
>>>   /dev/vcon3 -> /dev/virtio-console/clipboard
>>>
>>> - Some fqdn-like hierarchy, like
>>>
>>>   /dev/virtio-console/com/redhat/clipboard
>>>
>>>   which again can be created by udev scripts
>>>   
>>>       
>> And I dislike all of them.  What I'd rather have is these devices  
>> exposed as tty's with a sys attribute that exposed the name of the 
>> device.
>>     
>
> A sysfs attribute can even be exposed with a char device.
>
> I didn't want to venture more into tty after the hvc thing and the
> unexpected bugs that crept up (memory corruption, which is now fixed in
> linux-next). I'd rather just keep it limited to the subsystems I know.
>   

I don't think that's a good justification.

This device is very much a serial port.  I don't see any reason not to 
treat it like one.

Regards,

Anthony Liguori
