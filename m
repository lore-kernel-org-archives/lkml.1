Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbZBNNWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbZBNNWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 08:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZBNNVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 08:21:49 -0500
Received: from h155.mvista.com ([63.81.120.155]:19956 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751596AbZBNNVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 08:21:49 -0500
Message-ID: <4996C563.9090900@ru.mvista.com>
Date: Sat, 14 Feb 2009 16:21:39 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Hanno_B=F6ck?= <hanno@hboeck.de>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Very old IDE hard drive (240 MB) detected as 1.1 TB
References: <200902131428.40212.hanno@hboeck.de> <499584FC.2050104@gmail.com> <200902141352.24277.hanno@hboeck.de>
In-Reply-To: <200902141352.24277.hanno@hboeck.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hanno Böck wrote:

>> That would be worth investigating, yes.. If you can provide the dmesg
>> output from bootup, as well as the output of hdparm --Istdout on the
>> disk device, that would be useful..
>>     
>
> That (and a bit more, normal hdparm output, smartctl output) here:
> http://files.hboeck.de/conner/
>   

   It has the current capacity in words 57-58 swapped:

/dev/sdb:
0c5a 037f 0000 000a 8723 0275 0037 0030
000a 0000 2020 2020 2020 2020 2020 424d
3948 4d31 5020 2020 0003 0040 0004 302e
3336 2020 2020 436f 6e6e 6572 2050 6572
6970 6865 7261 6c73 2032 3430 4d42 202d
2043 5033 3032 3534 2020 2020 2020 8010
0000 0001 0000 0200 0202 0001 037f 000a
0037 0007 82da 0000 0000 0000 0000 0000


   It must be 82da 0007, not 0007 82da.
   IIRC, the IDE core doesn't trust the value reported in these words 
(and I have knowledge of some other old disks reporting a bogus value 
there), but liabata does (naively :-).

MBR, Sergei


