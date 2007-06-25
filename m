Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXFYVSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXFYVSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbXFYVSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:18:21 -0400
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:42867 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbXFYVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:18:20 -0400
Message-ID: <4680310D.6060206@opensound.com>
Date: Tue, 26 Jun 2007 00:18:05 +0300
From: Hannu Savolainen <hannu@opensound.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
CC: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <s5h4pkwi9u0.wl%tiwai@suse.de>
In-Reply-To: <s5h4pkwi9u0.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai kirjoitti:
> At Sun, 24 Jun 2007 19:51:38 +0200 (CEST),
> Tomasz K³oczko wrote:
>   
>> Few dayas ago OSS source code was oppened uder CDDL for Solaris and GLPv2 
>> for Linux:
>>
>> http://www.opensound.com/press/2007/oss-gpl-cddl.txt
>>
>> So this source without problems code can be integragrated in Linus tree 
>> and after this Linux can provide much better soud supoport than 
>> with current ALSA.
>>
>> Any plans for doing this ?
>>     
>
> Did you count the number of devices that tree supports?
> You'll loose the support of all new laptops and mobos sold in the last
> year :)
>   
They are all based on HD audio which is supported by OSS. Ok, our HDA 
driver driver still needs some work which was one of the reasons why we 
are moving to the community development model.
> Honestly, I'm not fully against changing the current code base (or
> crap, whatever, any childish name).  There are indeed many misdesigns.
> But, replacing with the above is no option, IMO.  The OSS have also
> many misdesigns, so the same argument would start again.  One should
> learn something from history...
>   
Exactly. Good to know that we are both thinking in the same way.
> Anyway, if it's going to be more constructive, I'm willing to join in.
>   
I think it's going to be constructive.

We have no intention to push OSS back to the kernel or to replace ALSA. 
That alternative is not realistic any more. In addition OSS is a 
cross-platform product and staying more or less outside various kernel 
trees should provide better flexibility.

What we would like to push is that the old "deprecated" OSS/Free are 
removed from the kernel. OSS/Free is based on about years old OSS API 
version which was too limited for many applications. Having OSS/Free in 
the kernel doesn't serve any purpose.

Also we would like to stop the silly OSS vs ALSA war. OSS and ALSA are 
rather different. Both of them have some good points and bad points. For 
ordinary users it doesn't matter which API is used by the applications 
as long as they work. Just the application developers can see the real 
difference. Some of them prefer OSS while some other prefer ALSA and 
this should be their "freedom of choice".

I think the ideal solution would be that both ALSA and OSS APIs can 
co-exist by sharing the same low level drivers (which has already been 
demonstrated). The low level driver interfaces in both systems are 
practically identical. This means that ALSA's core can work with OSS' 
drivers and vice versa.

Today both OSS and ALSA teams have to spend significant amounts of time 
in emulating the "alien" APIs. Making OSS and ALSA to co-exist will 
require some work in both sides but that should be nothing when compared 
to the effort required for emulation.

Just my 2 cents.

Best regards,

Hannu
