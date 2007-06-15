Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbXFOAhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbXFOAhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXFOAg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:36:57 -0400
Received: from smtpout.mac.com ([17.250.248.184]:65428 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbXFOAg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:36:56 -0400
In-Reply-To: <20070613195329.GC8273@ucw.cz>
References: <20070612161951.69e54751@the-village.bc.nu> <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com> <20070613195329.GC8273@ucw.cz>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5B4A5F89-935F-48DA-941D-54F7B0FC2FAA@mac.com>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: PC speaker
Date: Thu, 14 Jun 2007 20:36:49 -0400
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, at 15:53:30, Pavel Machek wrote:
>> Other great examples are hardware that allows you to control  
>> voltages, fan speeds, and operating frequencies. Sometimes you can  
>> overvoltage it directly and blow it immediately. Other times, you  
>> can increase the voltage and operating frequency and decrease the  
>> fan speed to the point where it stops spinning. This is possible  
>> on many modern graphics cards and CPUs.
>
> Not true for cpus; try it before spreading FUD. Thermal protection  
> will kill the machine when cpu goes over 95C or so.

Well, sorta.  Things tend to die early heat deaths if you repeatedly  
spike the temperature (different rates of thermal expansion and all  
that jazz).  If you alternated repeatedly between max-CPU/no-fan and  
no-CPU/max-fan, staying just within the thermal kill limits and  
spending 3/4 of the time at near max temp, you'd probably have a 30%  
chance to kill an average CPU within a couple weeks.

I know when designing the G5 CPU, IBM had to be _really_ careful  
about the variably high operating temperature.  Their first few  
designs ended up having BGA breakdown well before the desired  
lifetime due to thermal creep (long-duration at high temp) and  
fatigue shear failure (alternation between high and low temp).   
There's a paper somewhere on the web about the whole deal.

Cheers,
Kyle Moffett

