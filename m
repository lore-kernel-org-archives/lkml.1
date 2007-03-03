Return-Path: <linux-kernel-owner+w=401wt.eu-S1030669AbXCCPyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030669AbXCCPyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 10:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030670AbXCCPyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 10:54:31 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:56788 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030669AbXCCPya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 10:54:30 -0500
Message-ID: <45E99A45.9030506@gmail.com>
Date: Sat, 03 Mar 2007 16:54:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <45E996A0.6070700@gmail.com>
In-Reply-To: <45E996A0.6070700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jiri Slaby napsal(a):
> Andrew Morton napsal(a):
>> Temporarily at
>>
>>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 
> Weird behaviour of numlock and capslock on USB keyboard in X. After 

Hmm, it's not X related. Console behaves similarly.

> pressing

Or actually if some script tries to change LEDs (logout).

> those keys, keyboard "hangs" -- no sysrq, no lock leds are flashing.
> 
> After plug; unplug of the keyboard, it works unless I press the keys
> again.
> 
> There is nothing in dmesg. X log says
> (II) evdev brain: Rescanning devices (3).
> (II) evdev brain: Rescanning devices (4).
> (II) evdev brain: Rescanning devices (5).
> (II) evdev brain: Rescanning devices (6).
> (II) evdev brain: Rescanning devices (7).
> (II) evdev brain: Rescanning devices (8).
> (II) evdev brain: Rescanning devices (9).
> (II) evdev brain: Rescanning devices (10).
> (II) evdev brain: Rescanning devices (11).
> (II) evdev brain: Rescanning devices (12).
> (II) evdev brain: Rescanning devices (13).
> (II) evdev brain: Rescanning devices (14).
> in this kernel, but I don't know if this is relevant.
> 
> After booting back to .20-mm2 everything is OK.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
