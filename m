Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYAAVqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYAAVqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYAAVqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:46:24 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:41634 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYAAVqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:46:23 -0500
Message-ID: <477AB3DC.9080705@keyaccess.nl>
Date: Tue, 01 Jan 2008 22:42:52 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com>	<20080101161557.3ce2d5f8@the-village.bc.nu>	<20080101164338.GA901@elte.hu>	<20080101183238.74307174@weinigel.se>	<20080101184659.GA9250@elte.hu>	<20080101203518.26e889f2@weinigel.se>	<20080101210143.GB759@elte.hu> <20080101224241.2ce431bd@weinigel.se>
In-Reply-To: <20080101224241.2ce431bd@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-01-08 22:42, Christer Weinigel wrote:

> The data sheet for the Intel M8259A says:
> 
>     End of /RD to Next Command: 300 ns
>     End of /WR to Next Command: 370 ns
> 
> On the other hand, I don't know how all the i8253/i8259 clones or the
> numerous variants of Super I/O chips behave.  It wouldn't surprise me
> if some Super I/O chip uses the ISA bus clock to latch the values
> internally so that the delay is dependent on the bus frequency instead.

I wouldn't even be surprised if most all would...

Rene.
