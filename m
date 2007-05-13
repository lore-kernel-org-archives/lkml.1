Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbXEMSOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbXEMSOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbXEMSOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:14:23 -0400
Received: from mail.aknet.ru ([82.179.72.26]:56280 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbXEMSOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:14:23 -0400
Message-ID: <4647561E.7090702@aknet.ru>
Date: Sun, 13 May 2007 22:17:02 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] make pit clocksource continuous
References: <46464B5C.2080302@aknet.ru>	 <1179040612.22481.237.camel@localhost.localdomain>	 <4646D493.9000309@aknet.ru>	 <1179068094.22481.248.camel@localhost.localdomain>	 <46474175.7030205@aknet.ru>	 <1179075026.22481.273.camel@localhost.localdomain>	 <46474975.1080204@aknet.ru> <1179077772.22481.279.camel@localhost.localdomain>
In-Reply-To: <1179077772.22481.279.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thomas Gleixner wrote:
>>>> Does this mean that on even an older
>>>> boards (without acpi at all) the hrtimers
>>>> won't work?
>>> Not if PIT is the only clocksource available.
I was confused as to where the above "not" applies.

> It does _NOT_ work without pm_timer or hpet
Thanks, now its clear enough. :)

> hrtimer_get_res() works, but I have no idea why you need hrtimers in
> your driver at all.
This is a pc-speaker PCM driver which needs a
18.5KHz periodic freq at least (the normal freq
is 37KHz).
I used the PIT and only PIT for it in the past,
but now with using hrtimers, the PIT is no
longer enough. This is a bit annoying, and
really, after I added the flag to pit_clocksource,
it just started to work, so I thought something
can be done in order for it to keep working with
PIT only. But if there is no way to do it with
hrtimers, then oh well.

