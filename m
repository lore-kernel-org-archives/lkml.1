Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbXHEIGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbXHEIGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 04:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbXHEIFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 04:05:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60336 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbXHEIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 04:05:51 -0400
Date: Sun, 5 Aug 2007 10:05:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
Subject: Re: rtc max frequency setting
In-Reply-To: <46B5148E.50302@zytor.com>
Message-ID: <Pine.LNX.4.64.0708050956540.29913@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708050042560.14443@fbirervta.pbzchgretzou.qr>
 <46B5148E.50302@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 4 2007 17:06, H. Peter Anvin wrote:
>Jan Engelhardt wrote:
>> Hi,
>> 
>> with the old rtc.ko module, there was a /proc/sys/dev/rtc/max-user-freq 
>> that could be set. With rtc_cmos.ko (or the new rtc infrastructure in 
>> general), I am missing this file. Where can I set the max-user-freq now, 
>> or is this obsolete now? (mplayer prefers to have user-freq to be >= 1024.)
>
>Qemu wants something like this too.  Both of these really want something
>else, which is a high-frequency userspace timer.

Something like that. They use it to fire the virtual timer (RTC in
the guest), otherwise there is no way to simulate a HZ=1000 guest
(esp. Freebsd 6.0) in a HZ=100 host without busy-waiting.

For mplayer it is not that important (I'd even ask "what for?" since
other players do not need it either by default).

>What is the best way to do that on modern kernels?
>
>	-hpa
>

	Jan
-- 
