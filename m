Return-Path: <linux-kernel-owner+w=401wt.eu-S1763583AbXKMVgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583AbXKMVgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbXKMVgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:36:10 -0500
Received: from wrzx28.rz.uni-wuerzburg.de ([132.187.3.28]:58495 "EHLO
	mailrelay.rz.uni-wuerzburg.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759657AbXKMVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:36:09 -0500
Message-ID: <473A18C1.3030501@durtro.de>
Date: Tue, 13 Nov 2007 22:36:01 +0100
From: Markus Hirschmann <mh@durtro.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, jayakumar.video@gmail.com,
       Christian Magnusson <mag@mag.cx>, dtor@mail.ru,
       linux-kernel@vger.kernel.org
Subject: Re: Problems using quickcam_messenger on ARM (FYI)
References: <4730A379.9060706@durtro.de> <1194863992.8662.65.camel@gaivota> <4739FDBA.5010102@free.fr>
In-Reply-To: <4739FDBA.5010102@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry

Thierry Merle wrote:
> Hi Mauro,
> Mauro Carvalho Chehab a écrit :
>> Em Ter, 2007-11-06 às 18:25 +0100, Markus Hirschmann escreveu:
>>   
>>> Hello Kernel-Developer,
>>>
>>> Module quickcam_messenger seems to be broken (tried 2.6.18 and 2.6.22)
>>> on 2 different NSLU2 (ARM). Picture is attached. Same kernel and module 
>>> can be used without any problems on x86 here. I don't have any ARM 
>>> device beside the NSLU2, so I cannot check.
>>>
>>> The solution was to use Christian Magnusson's quickcam module. 
>>> Everything worked without any problem. Webcam is:
>>>     
>> Hmm... you're mentioning the quickcam module, but some of your logs are
>> related to usbvideo driver.
>>
>> On a quick glance, I didn't find anything that could explain your
>> troubles. It seems to be related to a wrong order at the output format
>> (for example, the driver is sending RGB, instead of BGR).
>>
>> It may also be an issue at the userspace application that is using the
>> wrong logic to deal with Big Endian.
>>
>>   
> The NSLU2 is based on a IXP420 processor that can change its endianess.
> I suppose Markus has installed the debian-arm distribution on his NSLU2
> so it is configured as little-endian.
> Nevertheless, I took a look at the code of quickcam messenger that is in
> usbvideo/
> This macro: RGB24_PUTPIXEL puts in memory the following bytes:
>                 *pf++ = (vb);
>                 *pf++ = (vg);
>                 *pf++ = (vr);
> vb, vg, vr are blue, green, red values.
> Since the driver is still v4l1 this can be normal(?)

Right, I forgot. Installed is the Debian ARM distribution. And I tried 
serveral different applications (motion, vgrabbj).

Best regards

Markus
