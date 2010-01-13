Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898Ab0AMMzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0AMMzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804Ab0AMMzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:55:25 -0500
Received: from smtp.nokia.com ([192.100.105.134]:32449 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0AMMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:55:24 -0500
Message-ID: <4B4DC2A7.5030108@nokia.com>
Date: Wed, 13 Jan 2010 14:55:03 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>,
       "Quadros Roger (Nokia-D/Helsinki)" <roger.quadros@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Add 'start-up time' to fixed voltage regulators
References: <4B4DB562.2080601@nokia.com> <20100113120327.GB27473@rakim.wolfsonmicro.main> <4B4DB94E.8080602@nokia.com> <20100113122612.GC27473@rakim.wolfsonmicro.main>
In-Reply-To: <20100113122612.GC27473@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2010 12:55:02.0691 (UTC) FILETIME=[9F268730:01CA944F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Jan 13, 2010 at 02:15:10PM +0200, Adrian Hunter wrote:
>> Mark Brown wrote:
> 
>>>> #include <linux/gpio.h>
>>>> +#include <linux/delay.h>
> 
>>> I think your MUA may have eaten the patch - it looks like the leading
>>> spaces got stripped which is liable to confuse things.
> 
>> Are you sure?  Looks fines to me.
> 
> The above should be
> 
>   >  #include <linux/gpio.h>
>   > +#include <linux/delay.h>
> 
> IIRC ie, a one character indent on the context as well as the changed
> lines.
> 

I meant that the space is, in fact, there.
e.g. see http://lkml.org/lkml/2010/1/13/186

>>> startup_delay?  Just in case we think of another delay, though I'm
>>> struggling to think of one right now so I'm not too worried.
> 
>> I am too lazy to change it unless there is something else too ;-)
> 
> On the other hand the cross tree issues will be annoying if it's changed
> later...
> 

OK
