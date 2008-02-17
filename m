Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYBQWFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYBQWFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYBQWFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:05:33 -0500
Received: from rtr.ca ([76.10.145.34]:4920 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYBQWFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:05:32 -0500
Message-ID: <47B8AFAA.30101@rtr.ca>
Date: Sun, 17 Feb 2008 17:05:30 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What's needed for a PCIe card to be recognized?
References: <20080216225932.22460d31@dilbert.local>	<20080216143946.6d532a41@laptopd505.fenrus.org>	<20080217015453.2a4e4142@dilbert.local>	<20080216182939.061c7246@laptopd505.fenrus.org>	<20080217133753.661cd98d@bluebox.local>	<20080217072927.4b6c5964@laptopd505.fenrus.org> <20080217174728.76e4231a@bluebox.local>
In-Reply-To: <20080217174728.76e4231a@bluebox.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans J. Koch wrote:
> Am Sun, 17 Feb 2008 07:29:27 -0800
> schrieb Arjan van de Ven <arjan@infradead.org>:
> 
>> On Sun, 17 Feb 2008 13:37:53 +0100
>> "Hans J. Koch" <hjk@linutronix.de> wrote:
>>>> Of course there's no driver for the wlan, but that's a different
>>>> story ;)
>>> I replaced that unsupported Atheros 5007 card with an ipw3945, so I
>>> haven't got that problem.
>> oh but then you have a MUCH bigger problem ;(
>> The bios of that animal is hardcoded to the 5007 (or at least
>> Atheros). If you stick your own card in, for FCC reasons, the bios
>> refuses the card.
..

s/FCC/brand protection by Atheros/

> Really? Unbelievable what these guys do to make my live harder...
> So, they might use some undocumented GPIO to turn the power on, and
> refuse that if they don't find the original card? Looks like I can't
> have WLAN on an EeePC (I won't run a tainted kernel). Stupid thing to
> sell a PC with Linux preinstalled but with hardware not supported in
> mainline.
..

Try it again with 2.6.25-rc2 and this module option:

    options pciehp pciehp_force=1

Just a thin hope, really, but it might work.

Cheers
