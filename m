Return-Path: <linux-kernel-owner+w=401wt.eu-S1764408AbXKOLcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764408AbXKOLcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765372AbXKOLcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:32:43 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:63124 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765247AbXKOLcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:32:42 -0500
Message-ID: <473C2D30.4070309@fr.ibm.com>
Date: Thu, 15 Nov 2007 12:27:44 +0100
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: [2.6.24-rc2-git5] kernel panic when config_sysfs = n
References: <473C2854.90305@fr.ibm.com> <b6fcc0a0711150330p276e8c74u3486b9c776f2c6ae@mail.gmail.com>
In-Reply-To: <b6fcc0a0711150330p276e8c74u3486b9c776f2c6ae@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On 11/15/07, Daniel Lezcano <dlezcano@fr.ibm.com> wrote:
>> When I tryed to boot with qemu a 2.6.24-rc2-git5 with sysfs disabled,
>> the boot fails when trying to mount root partition:
>>
>> "VFS: Cannot open root device "hda2" or unknown-block(0,0)
>> Please append a correct "root=" boot option; here are the available
>> partitions:
>> 0300    2097152 hda0300    2097152 hda driver: ide-disk
>>   driver: ide-disk
>>    0301     257008 hda1
>>    0302    1839442 hda2
>> 1600    4194302 hdc1600    4194302 hdc driver: ide-cdrom
>>   driver: ide-cdrom
>> Kernel panic - not syncing: VFS: Unable to mount root fs on
>> unknown-block(0,0)"
> 
> From CONFIG_SYSFS help text:
> 
> sysfs is currently used by the block subsystem to mount the root
> partition.  If sysfs is disabled you must specify the boot device on
> the kernel boot command line via its major and minor numbers.  For
> example, "root=03:01" for /dev/hda1.


Shame on me :)
Thanks a lot.
