Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbYAHNSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbYAHNSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYAHNR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:17:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:49215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYAHNR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:17:58 -0500
Date: Tue, 8 Jan 2008 14:17:49 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
In-Reply-To: <20080107232514.699155d6@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LSU.0.999.0801081352080.12636@be1.lrz>
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it>
 <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it>
 <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it>
 <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it>
 <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it>
 <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it>
 <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com>
 <alpine.LSU.0.999.0801072226060.16143@be1.lrz>
 <20080107232514.699155d6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/F862S0zteZHn0rrli9QMTWW4e+SRy2KmvBN1
 UETEXuZVcdUsDnU7w8hzBqeHhIoBk3aPxDpolhAZHbyG9h23qb
 KxOxP6xOJcXIIira5mSGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Alan Cox wrote:

> > But overclocking is not the problem for udelay, it would err to the safe 
> > side. The problem would be a BUS having < 8 MHz, and since the days of 
> > 80286, they are hard to find. IMO having an option to set the bus speed
> > for those systems should be enough.
> 
> If you get it wrong you risk data corruption. Not good, not clever, not
> appropriate. Basically the use of port 0x80 is the right thing to do for
> ISA devices and as 15 odd years of use has shown works reliably and
> solidly for ISA systems.

As long as there is no port 80 card or a similar device using it. If 
there is a port 80 card, ISA acess needing the delay does break, cause
the data corruption you fear and does cause this thread to be started.
Pest, Cholera ...

OTOH, maybe the 6-MHz-delay is the same as the 8-MHz-delay, and the kernel 
parameter is not needed.
-- 
Fun things to slip into your budget
A Romulan Cloaking device:
	The PHB won't know what it is but will be to chicken to ask
