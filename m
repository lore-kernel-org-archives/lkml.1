Return-Path: <linux-kernel-owner+w=401wt.eu-S934501AbXEMRUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbXEMRUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbXEMRUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:20:13 -0400
Received: from mail.aknet.ru ([82.179.72.26]:52820 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585AbXEMRUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:20:12 -0400
Message-ID: <46474975.1080204@aknet.ru>
Date: Sun, 13 May 2007 21:23:01 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] make pit clocksource continuous
References: <46464B5C.2080302@aknet.ru>	 <1179040612.22481.237.camel@localhost.localdomain>	 <4646D493.9000309@aknet.ru>	 <1179068094.22481.248.camel@localhost.localdomain>	 <46474175.7030205@aknet.ru> <1179075026.22481.273.camel@localhost.localdomain>
In-Reply-To: <1179075026.22481.273.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thomas Gleixner wrote:
>> Does this mean that on even an older
>> boards (without acpi at all) the hrtimers
>> won't work?
> Not if PIT is the only clocksource available.
So you mean it can work without both the
pm_timer and hpet? Sorry for bothering you
too much, but I am trying to use the hrtimers
in my driver module, so I'd like to know all
the corner-cases.

How can I test that situation when the hrtimers
work only with PIT? Apparently disabling the
pm_timer and hpet in config doesn't help testing
it at all, since it simply refuses to work then.

Should I use hrtimer_get_res() to see if the
hrtimers are available, or is there any better way?

