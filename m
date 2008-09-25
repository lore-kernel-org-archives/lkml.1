Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYIYI0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYIYI0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYIYI0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:26:37 -0400
Received: from ptb-relay02.plus.net ([212.159.14.146]:42140 "EHLO
	ptb-relay02.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYIYI0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:26:35 -0400
Message-ID: <48DB4B40.3000601@yahoo.com>
Date: Thu, 25 Sep 2008 09:26:40 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
CC: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net> <20080925024840.GA14575@kroah.com> <200809250829.22294.pluto@agmk.net> <48DB429C.4050904@yahoo.com>
In-Reply-To: <48DB429C.4050904@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Plusnet-Relay: a6ac5d03ff96c788633e62ad36b1077e
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Paweł Sikora wrote:
>> On Thursday 25 of September 2008 04:48:40 Greg KH wrote:
>>> What kernel modules do you currently use/rely on that are not in the
>>> main kernel tree?  Do you have links to them?  I'd be glad to add them.
>>
>> here's a quick list:
>>
>> - http://www.lirc.org
> 
> ^^^^ People are taking steps to adapt this to be included in kernel. See 
>  http://lwn.net/Articles/297770/ . I could have sworn I saw someone 
> posting an input layer patch for lirc the other day too... Aha - 
> http://lkml.org/lkml/2008/9/24/328 .
> 
>> - http://rt2x00.serialmonkey.com
> 
> Isn't this one already in the wireless tree? I believe it was merged in 
> 2.6.24 - 
> http://kernelnewbies.org/Linux_2_6_24#head-62e9ebf067c978bbf70898986c0aa3904d1a3543 
> .
> 
>> - http://aufs.sourceforge.net
> 
> I've read rumblings about one of the stacking FSes being merged but thus 
> far nothing seems to have happened - http://lwn.net/Articles/265240/ .
> 
>> - http://linux-uvc.berlios.de
> 
> USB video has already been merged into mainline in 2.6.25 - 
> http://kernelnewbies.org/Linux_2_6_26#head-6d4ee1ddea983f5c8ac491b8685a94ea6fa4132b 
> ! I'm using it on my eeepc...
> 
> Those are the ones I recognise off the top of my head. I'll have to 
> search with regard to the other ones you mentioned...


 > - http://sourceforge.net/projects/bluetooth-alsa

Allegedly deprecated in favour of a userspace ALSA plugin: 
http://www.mail-archive.com/debian-devel@lists.debian.org/msg253253.html


 > - http://www.unav-micro.com/Drivers.aspx -> 
AR81Family-linux-v1.0.1.0.tar.gz
 >   (e.g. asus-p5q-pro m/b has such ethernet port, pciid=1969:1026)

Isn't this the atl1e gigabit ethernet driver? Isn't this being merged 
into 2.6.27? - 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6a5325239c20202e18e21e94291bccc659fbf9e

 > - http://www.misdn.org

Isn't this going into 2.6.27? - http://lwn.net/Articles/291630/

 > - zaptel telephony driver [http://www.asterisk.org]
 >   with firmware 
[http://downloads.digium.com/pub/telephony/firmware/releases]

Renamed to DAHDI and developers apparently don't want it merged into 
mainline - 
http://driverdev.linuxdriverproject.org/pipermail/devel/2008-June/000475.html 
.

 > - toshiba bluetooth module [http://0bits.com/toshbt/toshbt-1.0.tar.gz]

I can't reach that URI on 0bits.com at the moment but a cached page 
linking to it says the following:

"I was fedup patching the kernel everytime i needed this bluetooth 
enabled on my Tecra M2, so since we can use modules, i modularised the 
necessary bits to make the bluetooth enabling independent of kernel. 
Here it is in all it's glory."

I'm not sure what the state of that one is or what issue it is working 
around...

-- 
Sitsofe | http://sucs.org/~sits/
