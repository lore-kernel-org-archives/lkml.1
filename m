Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab0BHVCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:02:21 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55722 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0BHVCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:02:20 -0500
Date: Mon, 8 Feb 2010 22:02:19 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100208210219.GA22039@rhlx01.hs-esslingen.de>
References: <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain> <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain> <alpine.LFD.2.00.1002082139360.2811@localhost.localdomain> <20100208205105.GA16990@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208205105.GA16990@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 09:51:05PM +0100, Andreas Mohr wrote:
> Looks like it:
> - another bootup also had lockup message
> - all /var/log/dmesg* have lockup message, oldest is:
> 2010-02-07 20:00 dmesg.4.gz
> 
> Linux version 2.6.33-rc6 (root@note) (gcc version 4.3.4 (Debian 4.3.4-6)) #3 Sun Jan 31 23:47:51 CET 2010

-rc4 and 2.6.32.3 don't show lockup message, instant bootup without any
visible delay.

Don't tell me I'm now supposed to try -rc5 and also rebuild -rc6 ;)
If so, do tell early so that I have lots of time to get it built...

Andreas Mohr
