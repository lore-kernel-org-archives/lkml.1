Return-Path: <linux-kernel-owner+w=401wt.eu-S1764908AbXF1RfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764908AbXF1RfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760948AbXF1RfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:35:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:52477 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756399AbXF1RfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:35:05 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1+rqlU9XSarNuPfV6sWXkCrwxMFFGxS0sTMsJXWWx
	4GBXFcTHK1rTJp
Message-ID: <4683F145.2060705@gmx.de>
Date: Thu, 28 Jun 2007 19:35:01 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22-rc6 spurious hangs
References: <4683BF16.40905@gmx.de> <20070628144741.GA437@tv-sign.ru> <4683CC89.80406@gmx.de> <20070628150826.GA487@tv-sign.ru>
In-Reply-To: <20070628150826.GA487@tv-sign.ru>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> As Ingo told me I run 'echo t > /proc/sysrq-trigger' this time. The
>>>> corresponding part of my syslogs is attached, as well as my kernel config.
>>> Could you try the patch below? It dumps some info when flush_workqueue()
>>> hangs.
>> I'm compiling a patched kernel right now. As I wrote in my former mail the
>> whole thing not easy to trigger. So it can take some time to get the info.
> 
> Forgot to say, if you manage to trigger the hang, please wait a couple of
> minutes to collect more info from flush_wait().

Seems today is my lucky day: I triggered it in just a few minutes.

The logfile is attached.

Thomas

-- 
keep mailinglists in english, feel free to send PM in german
