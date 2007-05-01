Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbXEATwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbXEATwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXEATwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:52:43 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:15355 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752573AbXEATwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:52:42 -0400
Message-ID: <46379A7E.3000109@interia.pl>
Date: Tue, 01 May 2007 21:52:30 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Natsemi DP83815 driver spaming
References: <46365887.3010705@interia.pl> <20070430205522.abad2481.akpm@linux-foundation.org> <20070501084639.GA528@sirena.org.uk> <46371590.4090004@interia.pl> <20070501180830.GA31630@sirena.org.uk>
In-Reply-To: <20070501180830.GA31630@sirena.org.uk>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: 8f406acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> eth0: Media selection timer tick.
>> eth0: possible phy reset: re-initializing
> 
> This is why the reset is being triggered - it's a workaround for a hardware
> bug which checks to make sure the hardware is in the state that the
> kernel thinks it is is going off.  The code has this explanatory comment:
> 
>  * 2) check for sudden death of the NIC:
>  *    It seems that a reference set for this chip went out with incorrect info,
>  *    and there exist boards that aren't quite right.  An unexpected voltage
>  *    drop can cause the PHY to get itself in a weird state (basically reset).
>  *    NOTE: this only seems to affect revC chips.
> 
Code commented out and NIC is working OK. Strange.
eth0: DSPCFG accepted after 0 usec.
eth0: link up.
eth0: Setting full-duplex based on negotiated link capability.
dspcfg = 0x00000000  np->dspcfg = 0x00005060
dspcfg = 0x00000000  np->dspcfg = 0x00005060
dspcfg = 0x00000000  np->dspcfg = 0x00005060
dspcfg = 0x00000000  np->dspcfg = 0x00005060
dspcfg = 0x00000000  np->dspcfg = 0x00005060
dspcfg = 0x00000000  np->dspcfg = 0x00005060
dspcfg = 0x00000000  np->dspcfg = 0x00005060

One problem solved in mean time :-)
> PCI: CS5530 video turned off.

[BTW, as Andrew said please don't drop people from the CC.]
I didn't. It is Thunderbird. I'm included instead of You. Fixed 
manually this time.

Regards
Rafa³


----------------------------------------------------------------------- Linda jako gospodyni domowa - zobacz!!!
>>> http://link.interia.pl/f1a79

