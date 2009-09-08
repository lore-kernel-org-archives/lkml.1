Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbZIHWAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbZIHWAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZIHWAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:00:48 -0400
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:49838 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbZIHWAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:00:47 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net AEF9B25729D
Message-ID: <4AA6D40F.6040600@arcor.de>
Date: Wed, 09 Sep 2009 01:00:47 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Juergen Beisert <jbe@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <20090908013800.296a5fb5@infradead.org> <4AA62E4E.4040700@arcor.de> <200909081332.46129.jbe@pengutronix.de>
In-Reply-To: <200909081332.46129.jbe@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 02:32 PM, Juergen Beisert wrote:
> On Dienstag, 8. September 2009, Nikos Chantziaras wrote:
>> On 09/08/2009 11:38 AM, Arjan van de Ven wrote:
>>> On Tue, 08 Sep 2009 10:19:06 +0300
>>>
>>> Nikos Chantziaras<realnc@arcor.de>   wrote:
>>>> latencytop has this to say:
>>>>
>>>>      http://foss.math.aegean.gr/~realnc/pics/latop1.png
>>>>
>>>> Though I don't really understand what this tool is trying to tell me,
>>>> I hope someone does.
>>>
>>> despite the untranslated content, it is clear that you have scheduler
>>> delays (either due to scheduler bugs or cpu contention) of upto 68
>>> msecs... Second in line is your binary AMD graphics driver that is
>>> chewing up 14% of your total latency...
>>
>> I've now used a correctly installed and up-to-date version of latencytop
>> and repeated the test.  Also, I got rid of AMD's binary blob and used
>> kernel DRM drivers for my graphics card to throw fglrx out of the
>> equation (which btw didn't help; the exact same problems occur).
>>
>> Here the result:
>>
>>       http://foss.math.aegean.gr/~realnc/pics/latop2.png
>>
>> Again: this is on an Intel Core 2 Duo CPU.
>
> Just an idea: Maybe some system management code hits you?

I'm not sure what is meant with "system management code."
