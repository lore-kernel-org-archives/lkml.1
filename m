Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZECJjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZECJjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 05:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZECJjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 05:39:07 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:52782 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZECJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 05:39:06 -0400
Message-ID: <49FD6634.1080602@web.de>
Date: Sun, 03 May 2009 11:39:00 +0200
From: Lee <lee-in-berlin@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090409 Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc4: compile fail with CONFIG_DRM_I915=y
References: <49FC4F88.3090403@web.de> <49FC7A13.8040807@oracle.com>
In-Reply-To: <49FC7A13.8040807@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/fA7ZOiabZtnWAAJ3Gap56pk2DuydOtuMaQbyp
	9muhApTBebxizmMDmnHirkRpg/B2TcTLPRxhacycRC/T7hmNkz
	l5MbvSGD5nH7kCNUUoMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Lee wrote:
>> Hi list,
>>
>> compiling 2.6.30-rc4 with following options will result in an compile
>> error:
>>
>> CONFIG_DRM_I915=y
>> CONFIG_ACPI_VIDEO=m
>>
>>
>> drivers/video/backlight/backlight.c: In function
>> ‘backlight_device_register’:
>> drivers/video/backlight/backlight.c:247: warning: format not a string
>> literal and no format arguments
>> drivers/video/output.c: In function ‘video_output_register’:
>> drivers/video/output.c:99: warning: format not a string literal and no
>> format arguments
>> drivers/usb/storage/libusual.c: In function ‘usu_probe_thread’:
>> drivers/usb/storage/libusual.c:159: warning: format not a string literal
>> and no format arguments
>> drivers/built-in.o: In function `intel_opregion_free':
>> (.text+0xaf051): undefined reference to `acpi_video_exit'
>> drivers/built-in.o: In function `intel_opregion_init':
>> (.text+0xaf411): undefined reference to `acpi_video_register'
>> make[1]: *** [.tmp_vmlinux1] Error 1
>> make[1]: Leaving directory `/home/randall/kernel-source'
>> make: *** [debian/stamp/build/kernel] Error 2
>>
>> Compiling the kernel with both options as module or both options
>> built-in results in a working kernel.
> 
> Len Brown posted a patch to fix this, although I can't find it in
> any email archives just now, so I'm appending it below.
> 
> 

Thanks! I'll keep an eye on it that it's merged for the next rc.
