Return-Path: <linux-kernel-owner+w=401wt.eu-S934713AbXHJWoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713AbXHJWoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXHJWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:43:51 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:39681 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbXHJWnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:43:47 -0400
Message-ID: <46BCE958.9040102@gmail.com>
Date: Sat, 11 Aug 2007 00:40:24 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Jegadeesh <kovaiteam@gmail.com>, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>, aacraid@adaptec.com
Subject: Re: Partition information lost on reboot.
References: <2e1f41c80708100517y736b8cd7xaebed333a0748a3@mail.gmail.com> <6bffcb0e0708100530u6087a963re61dddd8f48eb630@mail.gmail.com>
In-Reply-To: <6bffcb0e0708100530u6087a963re61dddd8f48eb630@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2007 02:30 PM, Michal Piotrowski wrote:

> [Adding linux-scsi and Adaptec support to CC]
> 
> On 10/08/07, Jegadeesh <kovaiteam@gmail.com> wrote:
>> Hi,
>>
>> I have a scsi disk on Adaptec ASC-29320 U320. I have created a linux
>> partition and ext3 filesystem over it.
>> Now the problem is, whenever the machine is rebooted, the partition
>> information to the OS is lost and I get an error saying it as a not valid
>> block device.
>> But fdisk tool shows the partitions, but "cat /proc/partitions" doesnt have
>> this. I need to do a "partprobe" and then have to mount it explicitly.
>>
>> What could be causing this problem. Given below are some of the command
>> outputs.

Is that the "Adaptec AIC79xx U320 support" (CONFIG_SCSI_AIC79XX) driver? If 
so, did you lower the "Initial bus reset delay" (default is 5000 ms) in the 
kernel configuration?

Rene.
