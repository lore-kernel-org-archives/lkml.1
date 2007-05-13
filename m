Return-Path: <linux-kernel-owner+w=401wt.eu-S934542AbXEMQqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934542AbXEMQqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759504AbXEMQqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:46:11 -0400
Received: from mail.aknet.ru ([82.179.72.26]:55407 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759336AbXEMQqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:46:08 -0400
Message-ID: <46474175.7030205@aknet.ru>
Date: Sun, 13 May 2007 20:48:53 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] make pit clocksource continuous
References: <46464B5C.2080302@aknet.ru>	 <1179040612.22481.237.camel@localhost.localdomain>	 <4646D493.9000309@aknet.ru> <1179068094.22481.248.camel@localhost.localdomain>
In-Reply-To: <1179068094.22481.248.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thomas Gleixner wrote:
> You need either pm_timer or hpet in order to switch to highres /
> dynticks. Are those enabled in the kernel config ?
Yes, both were enabled.
However, since this board is very old
(bios is dated 2000), I had "acpi=off".
Now removing that, makes the hrtimers to
work.
Does this mean that on even an older
boards (without acpi at all) the hrtimers
won't work?

Thanks!

