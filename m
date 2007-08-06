Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbXHFVk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbXHFVk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXHFVjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:39:45 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:35551 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752632AbXHFVjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:39:44 -0400
Message-ID: <46B79512.6090704@interia.pl>
Date: Mon, 06 Aug 2007 23:39:30 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
Cc: David Edwards <powertop@dpe.lusars.net>, power@bughost.org,
       Thomas Gleixner <tglx@linutronix.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org
Subject: Re: HPET force-enable investigations on Via VT8235
References: <20070806204249.GA25957@rhlx01.hs-esslingen.de>
In-Reply-To: <20070806204249.GA25957@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 4f58cacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
Hi, 
> So, *please* (I'd *love* to get this working somehow):
> whoever has a VT8235 and is listening here,
> - give a "lspci -nn" (two 'n'!), to figure out details of chipset revision etc.
> - give a "lspci -d 1106:3177 -xxx", to try to figure out whether there happen
>   to be additional magical "enable" bits to map in those HPET I/O areas which
>   some BIOS versions configure and some don't (that's my fragile theory
>   at least)
> - oh, and don't forget to tell whether HPET works or not
VT8235 does *NOT* have a HPET(*). Only part which has HPET is VT8237. It is device 
00:17.0 too, but only 1106:3227 has HPET enable and memory base registers. 
VT8235 one and only feature which doesn't have driver yet seems to be hardware 
watchdog.
> 
> Thanks a lot,
> 
> Andreas Mohr
(*) Datasheet revision 2.03 March 16, 2005
Regards
Rafał


----------------------------------------------------------------------
Jak najszybciej dostac sie na wymarzona plaze?
Znajdz trase ekspresowa

>>>http://link.interia.pl/f1b0c

