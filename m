Return-Path: <linux-kernel-owner+w=401wt.eu-S1030196AbXCGIQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbXCGIQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965089AbXCGIQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:16:11 -0500
Received: from mx0.towertech.it ([213.215.222.73]:55266 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030196AbXCGIQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:16:11 -0500
Date: Wed, 7 Mar 2007 09:16:03 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: <rol@as2917.net>
Cc: "'David Brownell'" <david-b@pacbell.net>, "'Adrian Bunk'" <bunk@stusta.de>,
       <linux-kernel@vger.kernel.org>, <a.zummo@towertech.it>,
       <rtc-linux@googlegroups.com>
Subject: Re: 2.6.21-rc2 : Oops in rtc_cmos...
Message-ID: <20070307091603.717dae82@inspiron>
In-Reply-To: <051e01c76072$fcdae290$4b00a8c0@donald>
References: <200703061132.29331.david-b@pacbell.net>
	<051e01c76072$fcdae290$4b00a8c0@donald>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 05:42:13 +0100
"Paul Rolland" <rol@as2917.net> wrote:

> Hello,
> 
> > > Yes, it does, so it's a Good One (tm),
> > 
> > And points out that $SUBJECT is misleading; the root cause of
> > the oops isn't rtc_cmos.  Workaround, don't enable the legacy
> > driver for this hardware.
> 
> Well, sorry for that, but my point was that without enabling
> CONFIG_DRV_RTC_CMOS and only using CONFIG_RTC, my dmesg says :
> 
> drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

 yep. the layer the copies the hw clock to the system clock
 is saying that it cannot find any driver to work on. so
 you made the correct move in searching a driver. :)

> > > drivers/rtc/hctosys.c: unable to open rtc device (rtc0) 
> > Because probing 00:03 failed, was never fully usable.
> > So then rtc0 couldn't be found.  You'd get the same
> > message if, say, the RTC was loaded as a module.
> 
> It seems to me that the DRV_RTC_CMOS and the "standard" CONFIG_RTC
> shouldn't be used at the same time... Am I correct on that ? 
> Wouldn't it be better to have this dependancy enforced ?

 I will try to push a patch asap.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

