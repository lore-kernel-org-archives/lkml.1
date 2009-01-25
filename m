Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZAYVPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZAYVPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZAYVO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:14:58 -0500
Received: from lucidpixels.com ([75.144.35.66]:52015 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZAYVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:14:57 -0500
Date: Sun, 25 Jan 2009 16:14:56 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bill Davidsen <davidsen@tmr.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
In-Reply-To: <497CD5F3.8030901@tmr.com>
Message-ID: <alpine.DEB.1.10.0901251614160.16676@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan> <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
 <alpine.DEB.1.10.0901250726530.10805__44823.8515914001$1232890466$gmane$org@p34.internal.lan> <497CD5F3.8030901@tmr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Jan 2009, Bill Davidsen wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>> 
>>> 
>>> 
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>> 
>>>> 
>>>> 
>>>> On Sun, 25 Jan 2009, Alan Cox wrote:
>>>> 
>>>>> Easiest is to use labels. Old ide will keep hda,b,c,d constant
>>>>> providing you have interfaces using the legacy IDE port mappings (0x1f0
>>>>> and 0x170). Libata doesn't do that as pretty much every distribution had
>>>>> already switched to volume labels, and the user space can do the job far
>>>>> better than the kernel - especially as the newer devices with modern
>>>>> interfaces don't have the old BIOS/DOS legacy ideas any more.
>>>>> 
>>>>> Mount by label also means you can flip back and forth between the
>>>>> different drivers and kernel revisions.
>>>>> 
>>>>> Alan
>>>>> 
>>> It comes with one :)
>>> # xfs_admin -u  /dev/sdd2
>>> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>>> 
>>> Will try to use this to boot; however, I'd prefer the labels over the 
>>> UUID, wish there was an easy way to set it.
>>> 
>>> Justin.
>>> 
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>> 
>> 
>> One final question, without udev, how does one determine the UUID of a 
>> non-XFS
>> partition, e.g., swap?
>> 
> One uses blkid. Which suggests that you can solve your name problem by not 
> using names and switching to UUID.

This will fix the /etc/fstab issue but not LILO/boot one, per the earlier 
poster, need an initrd/etc for that.

Justin.
