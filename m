Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXJCNll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXJCNll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbXJCNlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:41:31 -0400
Received: from mail.tmr.com ([64.65.253.246]:38085 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbXJCNla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:41:30 -0400
Message-ID: <47039D80.6060805@tmr.com>
Date: Wed, 03 Oct 2007 09:47:44 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: shutdown -h now, 2.6.23-rc8 & 9
References: <200710020650.02613.gene.heskett@gmail.com> <4702C401.4050009@tmr.com> <200710022217.53972.gene.heskett@gmail.com>
In-Reply-To: <200710022217.53972.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Tuesday 02 October 2007, Bill Davidsen wrote:
>   
>> Gene Heskett wrote:
>>     
>>> Indeed it went to the system halted message and just sat there.  I hadn't
>>> yet booted to rc9 as amanda was running, so I did just a few minutes ago.
>>>
>>> After the reboot to rc9, I ran a make xconfig again to check that the
>>> option was enabled, but it seems to have disappeared from the menus in
>>> xconfig.
>>>
>>> Why was this removed?  Or if moved, where to?
>>>       
>> What? Was what removed?
>>     
>
> This phrase has not existed in any .config newer than 2.6.23-rc1 here:
> CONFIG_APM_REAL_MODE_POWER_OFF=y
>
>
>   
Yes, it's still there as of 23-rc8-git5, the latest source I've built on 
this machine. If you start menuconfig and search for the value, (I used 
"/APM") you will see that it now depends on various other options. I 
haven't personally needed it in a long time, but there are ACPI 
implementations which are seriously broken. And probably some embedded 
hardware and/or hand-held devices now.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

