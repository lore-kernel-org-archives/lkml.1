Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbXERQb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbXERQb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbXERQbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:31:21 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:33002 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756616AbXERQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:31:21 -0400
In-Reply-To: <1179499713.12981.75.camel@chaos>
References: <200705172142.26739.sshtylyov@ru.mvista.com> <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org> <464C99FF.8080404@ru.mvista.com> <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org> <464C9E67.2020909@ru.mvista.com> <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org> <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com> <464DADFC.3080802@ru.mvista.com>  <464DB800.40702@genesi-usa.com> <1179499713.12981.75.camel@chaos>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org>
Cc: Matt Sealey <matt@genesi-usa.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Robert Schwebel <r.schwebel@pengutronix.de>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Fri, 18 May 2007 11:31:19 -0500
To: Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18, 2007, at 9:48 AM, Thomas Gleixner wrote:

> On Fri, 2007-05-18 at 15:28 +0100, Matt Sealey wrote:
>>>> I guess the real question is, how high resolution does a high  
>>>> resolution
>>>> timer need to be,
>>>
>>>    In the order of microseconds.
>>
>> I think both the MPC52xx GPT0-7 and the SLT0-1 fulfil this fairly
>> easily.
>
> There is some basic work for MPC5200 available:
>
> http://www.pengutronix.de/oselas/bsp/phytec/index_en.html#phyCORE- 
> MPC5200B-tiny

I asked this earlier, but figured you might have a better insight.   
Is their value in having 'drivers' for more than one clock source?   
I'd say most (of not all) the PPC SoCs have timers on the system side  
that we could provide drivers for, I'm just not sure if that does  
anything for anyone.

- k
