Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbXERQyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbXERQyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbXERQyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:54:47 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:4441 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbXERQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:54:46 -0400
Message-ID: <464DDA6D.2010206@genesi-usa.com>
Date: Fri, 18 May 2007 17:55:09 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Robert Schwebel <r.schwebel@pengutronix.de>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com>	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>	 <464C99FF.8080404@ru.mvista.com>	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>	 <464C9E67.2020909@ru.mvista.com>	 <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org>	 <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com>	 <464DADFC.3080802@ru.mvista.com>  <464DB800.40702@genesi-usa.com>	 <1179499713.12981.75.camel@chaos>	 <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org> <1179507059.12981.81.camel@chaos>
In-Reply-To: <1179507059.12981.81.camel@chaos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas Gleixner wrote:
> On Fri, 2007-05-18 at 11:31 -0500, Kumar Gala wrote:
>> I asked this earlier, but figured you might have a better insight.   
>> Is their value in having 'drivers' for more than one clock source?   
>> I'd say most (of not all) the PPC SoCs have timers on the system side  
>> that we could provide drivers for, I'm just not sure if that does  
>> anything for anyone.
> 
> Not necessarily for the tick/highres stuff, but clock events allows
> other users as well to utilize such facilities. We have no users yet,
> but there are drivers, which utilize special timer hardware with nice
> #ifdeffery to allow the driver to be shared. This might be a useful
> thing for such stuff.

*ahem*

Please indulge my laziness and recommend me one or two to look at? I'm
no good at guessing what to grep for to find an example (I wonder if
we have any candidates in the ppc tree mostly..)

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations
