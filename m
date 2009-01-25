Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZAYVNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZAYVNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZAYVNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:13:36 -0500
Received: from mail.tmr.com ([64.65.253.246]:44727 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZAYVNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:13:36 -0500
Message-ID: <497CD5F3.8030901@tmr.com>
Date: Sun, 25 Jan 2009 16:13:23 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 pango-text SeaMonkey/1.1.14
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan> <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan> <alpine.DEB.1.10.0901250726530.10805__44823.8515914001$1232890466$gmane$org@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0901250726530.10805__44823.8515914001$1232890466$gmane$org@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> 
> 
> On Sun, 25 Jan 2009, Justin Piszcz wrote:
> 
>>
>>
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>
>>>
>>>
>>> On Sun, 25 Jan 2009, Alan Cox wrote:
>>>
>>>> Easiest is to use labels. Old ide will keep hda,b,c,d constant
>>>> providing you have interfaces using the legacy IDE port mappings (0x1f0
>>>> and 0x170). Libata doesn't do that as pretty much every distribution 
>>>> had
>>>> already switched to volume labels, and the user space can do the job 
>>>> far
>>>> better than the kernel - especially as the newer devices with modern
>>>> interfaces don't have the old BIOS/DOS legacy ideas any more.
>>>>
>>>> Mount by label also means you can flip back and forth between the
>>>> different drivers and kernel revisions.
>>>>
>>>> Alan
>>>>
>> It comes with one :)
>> # xfs_admin -u  /dev/sdd2
>> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>>
>> Will try to use this to boot; however, I'd prefer the labels over the 
>> UUID, wish there was an easy way to set it.
>>
>> Justin.
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
> 
> One final question, without udev, how does one determine the UUID of a 
> non-XFS
> partition, e.g., swap?
> 
One uses blkid. Which suggests that you can solve your name problem by not using 
names and switching to UUID.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
