Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYIEV0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYIEV0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYIEV0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:26:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53225 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbYIEV0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:26:09 -0400
Message-ID: <48C1A004.2030607@oracle.com>
Date: Fri, 05 Sep 2008 14:09:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Nicolas Pitre <nico@cam.org>, Dmitry Torokhov <dtor@insightbb.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] ucb1400_ts depends SND_AC97_BUS
References: <20061209003635.e778ff76.randy.dunlap@oracle.com>	<200612092150.02940.dtor@insightbb.com>	<20061209185737.1768315d.randy.dunlap@oracle.com>	<200612092205.19358.dtor@insightbb.com>	<Pine.LNX.4.64.0612092212410.2630@xanadu.home>	<20061209210945.5abe2d89.randy.dunlap@oracle.com>	<Pine.LNX.4.64.0612102244140.2630@xanadu.home>	<20080904195744.f367cd2d.randy.dunlap@oracle.com>	<alpine.LFD.1.10.0809050028590.23787@xanadu.home>	<20080904214444.0dccf859.randy.dunlap@oracle.com>	<alpine.LFD.1.10.0809050104560.23787@xanadu.home>	<s5htzcvt7id.wl%tiwai@suse.de>	<alpine.LFD.1.10.0809051049460.23787@xanadu.home>	<s5hhc8u8soi.wl%tiwai@suse.de>	<alpine.LFD.1.10.0809051231120.23787@xanadu.home> <s5hprniv7ep.wl%tiwai@suse.de>
In-Reply-To: <s5hprniv7ep.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Fri, 05 Sep 2008 12:32:32 -0400 (EDT),
> Nicolas Pitre wrote:
>> On Fri, 5 Sep 2008, Takashi Iwai wrote:
>>
>>> At Fri, 05 Sep 2008 10:52:25 -0400 (EDT),
>>> Nicolas Pitre wrote:
>>>> On Fri, 5 Sep 2008, Takashi Iwai wrote:
>>>>
>>>>>> This was fixed 2 years ago.  Who broke it this time?
>>>>> Oh, it must be me.
>>>> I think both your patch and the one I previously posted are needed.
>>> Could you repost?  I can't find it easily now.
> 
> Thanks.  For linux-next, yes, it's needed.  But it's not for 2.6.27.
> 
> Meanwhile, my fix should be included in 2.6.27 since it's a
> regression.
> 
> Randy, could you check whether these two patches fix your problem?
> I'll put my patch to my tree for the next pull request after your
> confirmation.

Yes, all fixed/good.  Thanks.


> Can Nicolas's patch be to input tree, or any other taker?
> 
> 
> thanks,
> 
> Takashi
> 
>> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
>> index 6e1e8c6..22cf319 100644
>> --- a/drivers/input/touchscreen/Kconfig
>> +++ b/drivers/input/touchscreen/Kconfig
>> @@ -219,7 +219,6 @@ config TOUCHSCREEN_ATMEL_TSADCC
>>  
>>  config TOUCHSCREEN_UCB1400
>>  	tristate "Philips UCB1400 touchscreen"
>> -	select AC97_BUS
>>  	depends on UCB1400_CORE
>>  	help
>>  	  This enables support for the Philips UCB1400 touchscreen interface.
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index 5dba165..70355d3 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -52,6 +52,7 @@ config HTC_PASIC3
>>  
>>  config UCB1400_CORE
>>  	tristate "Philips UCB1400 Core driver"
>> +	select AC97_BUS
>>  	help
>>  	  This enables support for the Philips UCB1400 core functions.
>>  	  The UCB1400 is an AC97 audio codec.
>>
>>
>> Nicolas
>>

