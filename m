Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbZE0US0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbZE0US0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762228AbZE0UNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:13:00 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:46664 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762639AbZE0UM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:12:59 -0400
Message-ID: <4A1D9EC2.4090602@hp.com>
Date: Wed, 27 May 2009 16:12:50 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
CC: Martin Knoblauch <knobi@knobisoft.de>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
       Kay Sievers <kay.sievers@vrfy.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
References: <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <1241014725.15095.19.camel@marge.simson.net> <20090505154911.e0309a4f.akpm@linux-foundation.org> <1241585140.5196.28.camel@marge.simson.net> <957194.27869.qm@web32605.mail.mud.yahoo.com> <1241599065.18090.18.camel@marge.simson.net> <461911.6351.qm@web32603.mail.mud.yahoo.com> <20090526233102.b86e7f84.akpm@linux-foundation.org> <20090527112153.GE5816@parisc-linux.org> <840102.98312.qm@web32603.mail.mud.yahoo.com> <4A1D8161.2020009@hp.com> <0F5B06BAB751E047AB5C87D1F77A7788694630B931@GVW0547EXC.americas.hpqcorp.net>
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A7788694630B931@GVW0547EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miller, Mike (OS Dev) wrote:
>>>  Finally, today I built the ccsii driver into the kernel. 
>> It was previously modularized and loaded from initrd. The 
>> second "sysfs" line went away. But does this make cciss 
>> guilty? It is now loaded about 2 seconds earlier in the boot 
>> sequence, which is a big change in timing I guess.
>>>  Enlighten me :-)
>> No idea what is going on, but since I saw your May 20 
>> message, I have been trying to wake up someone whose day job 
>> it should be to care about dl380s and smartarrays. :)
> 
> What? I know Martin has pinged me in the past, but I do not think it was about this issue. If there's multiple sysfs entries for cciss I can't explain that offhand. We do little to nothing for sysfs in the driver.
> Had something similiar happen recently where "/" changed to "!". Had do to with our nested directory structure, /dev/cciss/name vs /dev/name. But we did not make that change, either.

It was not you that I was trying to get to look at this...
but now that I have your attention :)

I did not think it pointed at cciss or the sysfs entry as
being the problem.  I was wondering more about platform probe
timing, the bios, and how each card firmware reacts given
what I thought the patch did.  I could be totally wrong about
that as I work at the filesystem level.

We have not seen the problem yet but we have different
proliants/smartarrays.

If you can try it on matching hardware, great, if not
then someone will eventually find a system to test it.

jim
