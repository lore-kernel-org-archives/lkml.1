Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbXKXLOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbXKXLOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 06:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXKXLO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 06:14:29 -0500
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:39910 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbXKXLO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 06:14:28 -0500
Date: Sat, 24 Nov 2007 12:14:25 +0100
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
To: BERTRAND =?iso-8859-1?Q?Jo=EBl?= <joel.bertrand@systella.fr>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NETDEV WATCHDOG (3Com 3c905 adapter)
Message-ID: <20071124111425.GA29778@newton.mathematik.tu-chemnitz.de>
References: <4746C44B.8040008@systella.fr> <4746F747.4010906@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4746F747.4010906@systella.fr>
User-Agent: Mutt/1.4.2.1i
Content-Transfer-Encoding: 8BIT
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.3 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: c4e529ea06550f8ae756d457c1b9e21b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 04:52:39PM +0100, BERTRAND Joël wrote:
> BERTRAND Joël wrote:
> >    Hello,
> >
> >    Since I have installed a 2.6.23.1 linux kernel on my U60, I can see 
> >several NETDEV WATCHDOG. This trouble never occurs with 2.6.23-rc4.
> >This bug occurs after a random uptime.
> 
> 	I have made the same constation this evening on a amd64/up with two 
> 3C905 and a 2.6.21.3 linux kernel... This evening, I have rebooted my 
> U60 with a 2.6.23.8 kernel and the same 3C905 runs fine. Wait and see 
> (but I suspect a kernel bug...).
> 
> 	For main linux kernel list:
> 
> >End of dmesg :
> >
> >NETDEV WATCHDOG: eth2: transmit timed out
> >eth2: transmit timed out, tx_status 00 status 8601.
> >  diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
> >eth2: Interrupt posted but not delivered -- IRQ blocked by another device?

This looks like a problem that several network drivers had recently.
The problem was genirq related and should be fixed in 2.6.23,
so I'm surprised that this happens with 2.6.23.1 but not with 2.6.23-rc4.

Steffen
