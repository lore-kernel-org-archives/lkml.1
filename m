Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473Ab0AMMPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0AMMPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773Ab0AMMPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:15:20 -0500
Received: from smtp.nokia.com ([192.100.105.134]:29497 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab0AMMPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:15:20 -0500
Message-ID: <4B4DB94E.8080602@nokia.com>
Date: Wed, 13 Jan 2010 14:15:10 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>,
       "Quadros Roger (Nokia-D/Helsinki)" <roger.quadros@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Add 'start-up time' to fixed voltage regulators
References: <4B4DB562.2080601@nokia.com> <20100113120327.GB27473@rakim.wolfsonmicro.main>
In-Reply-To: <20100113120327.GB27473@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2010 12:15:09.0973 (UTC) FILETIME=[0CFABC50:01CA944A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Jan 13, 2010 at 01:58:26PM +0200, Adrian Hunter wrote:
> 
>> Add a field to specify a delay for the start-up time of
>> a fixed voltage regulator.
> 
>> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but...
> 
>> #include <linux/regulator/driver.h>
>> #include <linux/regulator/fixed.h>
>> #include <linux/gpio.h>
>> +#include <linux/delay.h>
> 
> I think your MUA may have eaten the patch - it looks like the leading
> spaces got stripped which is liable to confuse things.
> 

Are you sure?  Looks fines to me.

>> --- a/include/linux/regulator/fixed.h
>> +++ b/include/linux/regulator/fixed.h
>> @@ -25,6 +25,7 @@ struct regulator_init_data;
>>  * @microvolts:		Output voltage of regulator
>>  * @gpio:		GPIO to use for enable control
>>  * 			set to -EINVAL if not used
>> + * @delay:		Start-up time in microseconds
> 
> startup_delay?  Just in case we think of another delay, though I'm
> struggling to think of one right now so I'm not too worried.
> 

I am too lazy to change it unless there is something else too ;-)
