Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbXERPhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbXERPhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbXERPhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:37:25 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:2430 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbXERPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:37:24 -0400
Message-ID: <464DC844.4040101@genesi-usa.com>
Date: Fri, 18 May 2007 16:37:40 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Robert Schwebel <r.schwebel@pengutronix.de>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com>	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>	 <464C99FF.8080404@ru.mvista.com>	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>	 <464C9E67.2020909@ru.mvista.com>	 <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org>	 <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com>	 <464DADFC.3080802@ru.mvista.com>  <464DB800.40702@genesi-usa.com> <1179499713.12981.75.camel@chaos>
In-Reply-To: <1179499713.12981.75.camel@chaos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I already have that stuff, but it only implements the decrementer (in fact
it's the patch submitted at the beginning of this thread).

I got it because I was far more interested in the GPIO handling..

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations

Thomas Gleixner wrote:
> On Fri, 2007-05-18 at 15:28 +0100, Matt Sealey wrote:
>>>> I guess the real question is, how high resolution does a high resolution
>>>> timer need to be,
>>>    In the order of microseconds.
>> I think both the MPC52xx GPT0-7 and the SLT0-1 fulfil this fairly
>> easily.
> 
> There is some basic work for MPC5200 available:
> 
> http://www.pengutronix.de/oselas/bsp/phytec/index_en.html#phyCORE-MPC5200B-tiny
> 
> 	tglx
> 
> 
