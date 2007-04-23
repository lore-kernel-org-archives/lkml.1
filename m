Return-Path: <linux-kernel-owner+w=401wt.eu-S1161512AbXDWMOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161512AbXDWMOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161515AbXDWMOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:14:40 -0400
Received: from mail.atmel.fr ([81.80.104.162]:54066 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161467AbXDWMOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:14:39 -0400
X-Greylist: delayed 1799 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2007 08:14:38 EDT
Message-ID: <462C9C17.3070402@rfo.atmel.com>
Date: Mon, 23 Apr 2007 13:44:23 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux@bohmer.net
CC: Andrew Victor <andrew@sanpeople.com>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org
Subject: Re: gtod/clocksource/clockevents documentation
References: <3efb10970704211414q7c66c154m79cc06db61eb76be@mail.gmail.com>
In-Reply-To: <3efb10970704211414q7c66c154m79cc06db61eb76be@mail.gmail.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remy Bohmer :
> Hello All,
> 
> I need to implement a gtod/clocksource/clockevents implementation for
> the Atmel ARM AT91SAM9261 CPU, and I am looking for some kernel
> (interface) documentation about these mechanisms.

[..]

> I hacked something which now makes the RT kernel to boot, but the
> time-of-day warps several minutes per second, back and forward in
> time... ;-)

I recall there is a patch by Michel Benoit that solves some issues on 
gettimeoffset()/gettimeofday(). It is in the ARM patch queue here :
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4149/1
and will be included in the upcoming kernel.

Hope that it addresses this problem and that it will help you.

Regards,
-- 
Nicolas Ferre


