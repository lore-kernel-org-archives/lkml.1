Return-Path: <linux-kernel-owner+w=401wt.eu-S1751281AbXEXRbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbXEXRbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXEXRau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:30:50 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15489 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbXEXRas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:30:48 -0400
X-IronPort-AV: i="4.14,574,1170651600"; 
   d="scan'208"; a="30852023:sNHT31709923"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Paul Mundt" <lethal@linux-sh.org>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
Date: Thu, 24 May 2007 13:32:30 -0400
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bryan Wu" <Bryan.Wu@analog.com>
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com> <200705240929.51696.rgetz@blackfin.uclinux.org> <20070524152318.GA4491@linux-sh.org>
In-Reply-To: <20070524152318.GA4491@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241332.30335.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 May 2007 17:29:54.0843 (UTC) FILETIME=[249C76B0:01C79E29]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24 May 2007 11:23, Paul Mundt pondered:
> 
> Calling it a periodic timer when its in periodic timer mode makes sense.

No disagreements - but I don't think that a watchdog that doesn't cause a 
reset is a periodic timer.

> Why you would want to interface that with a userspace watchdog daemon is
> beyond me, they're conceptually unrelated.

Agreed again - periodic timers have nothing to do with watchdogs. This is 
where I am confused about why you are saying that the only event a watchdog 
can have is a hard reset.

> Please read my original mail on the subject. 

I did. Twice - but maybe I am still missing something. (sorry)

> I'm not advocating hiding a 
> clocksource somewhere in the depths of CONFIG_WATCHDOG, they're
> completely unrelated.

I (and many others) consider a "watchdog" a clock sink - something that needs 
to be poked within certain limits (too fast can indicate a failures just as 
too slow is a failure).

The event or how something is notified of the failure of the watchdog to be 
serviced shouldn't determine what the name is.

    What's in a name? that which we call a watchdog
    By any other name would smell as sweet;
                                         -Bill S

-Robin
