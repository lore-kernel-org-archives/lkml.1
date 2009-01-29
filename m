Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbZA2Xo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbZA2Xo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZA2XoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:44:21 -0500
Received: from main.gmane.org ([80.91.229.2]:47428 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbZA2XoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:44:20 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
Date: Thu, 29 Jan 2009 18:44:09 -0500
Message-ID: <49823F49.4000407@tmr.com>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan> <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan> <alpine.DEB.1.10.0901250726530.10805__44823.8515914001$1232890466$gmane$org@p34.internal.lan> <497CD5F3.8030901@tmr.com> <alpine.DEB.1.10.0901251614160.16676@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-ide@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
In-Reply-To: <alpine.DEB.1.10.0901251614160.16676@p34.internal.lan>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Sun, 25 Jan 2009, Bill Davidsen wrote:
> 
>> Justin Piszcz wrote:
>>>
>>>
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>
>>>>
>>>>
>>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>>
>>>>>
>>>>>
>>>>> On Sun, 25 Jan 2009, Alan Cox wrote:
>>>>>
>>>>>> Easiest is to use labels. Old ide will keep hda,b,c,d constant
>>>>>> providing you have interfaces using the legacy IDE port mappings 
>>>>>> (0x1f0
>>>>>> and 0x170). Libata doesn't do that as pretty much every 
>>>>>> distribution had
>>>>>> already switched to volume labels, and the user space can do the 
>>>>>> job far
>>>>>> better than the kernel - especially as the newer devices with modern
>>>>>> interfaces don't have the old BIOS/DOS legacy ideas any more.
>>>>>>
>>>>>> Mount by label also means you can flip back and forth between the
>>>>>> different drivers and kernel revisions.
>>>>>>
>>>>>> Alan
>>>>>>
>>>> It comes with one :)
>>>> # xfs_admin -u  /dev/sdd2
>>>> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>>>>
>>>> Will try to use this to boot; however, I'd prefer the labels over 
>>>> the UUID, wish there was an easy way to set it.
>>>>
>>>> Justin.
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>
>>> One final question, without udev, how does one determine the UUID of 
>>> a non-XFS
>>> partition, e.g., swap?
>>>
>> One uses blkid. Which suggests that you can solve your name problem by 
>> not using names and switching to UUID.
> 
> This will fix the /etc/fstab issue but not LILO/boot one, per the 
> earlier poster, need an initrd/etc for that.
> 
Good point, I have not used LILO since about Slackware 8.1, or any system w/o 
initrd in ages. I suppose there is a benefit to running without initrd, but I 
confess that I can't remember what it is. So I don't immediately consider the 
issues and limitations if you run without initrd.

Well I answered how to GET the UUID, he didn't ask me how to USE it. And I 
certainly didn't think of it, even though the info was there. :-(

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

