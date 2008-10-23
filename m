Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYJWS6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYJWS6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbYJWS61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:58:27 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:37516 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676AbYJWS60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:58:26 -0400
Message-ID: <4900C949.6040604@free.fr>
Date: Thu, 23 Oct 2008 20:58:17 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080829 Iceape/1.1.12 (Debian-1.1.12-1)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Tejun Heo <tj@kernel.org>, David Greaves <david@dgreaves.com>,
       linux-ide@vger.kernel.org,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] SMART to USB/sata dock in 2.6.27-rc5
 doesn't work
References: <48EE7E0A.8040701@dgreaves.com> <48F40164.5000502@kernel.org> <48F641A3.5080609@free.fr> <4900A0A7.3090102@rtr.ca>
In-Reply-To: <4900A0A7.3090102@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> matthieu castet wrote:
>> Hi,
>>
>> Tejun Heo wrote:
>>> David Greaves wrote:
>>>> Error Counter logging not supported
>>>> Device does not support Self Test logging
>>>
>>> The USB bridge should support SAT (SCSI-ATA translation) and many
>>> don't.  Nothing much can be done about it.  The hardware just don't know
>>> how to do it.
>>>
>> That true that the hardware should support SAT, but even if it support 
>> it, linux need some patches to support SAT over USB. See 
>> http://thread.gmane.org/gmane.linux.scsi/43688 and the patch mentioned 
>> in the thread.
> ...
> 
> Ahh.. Great!  This mostly fixes smartctl operation on at least two
> of my USB drive enclosures here:
> 
>    1. a recent rev.  2.5" NexStar-3 SATA enclosure.
>    2. a 250GB 2.5" WD "Passport" external USB drive/enclosure.
> 
> With the patch, this command line works for me:
> 
>    smartctl -a -dsat -T permissive /dev/sdb
> And hdparm just works regardless, with or without the patch.
> 
> 
It should work without permissive, permissive was need without the patch.

You said hdparm works without the patch. I wonder how it work. IRRC it 
asks check condition stuff for every command. I am interested to see the 
hdparm --verbose output without the patch.


BTW somebody is trying to push a patch similar to this one to 
usb-storage driver : 
https://lists.one-eyed-alien.net/pipermail/usb-storage/2008-October/004096.html


Matthieu
