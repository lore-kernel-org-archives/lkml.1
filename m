Return-Path: <linux-kernel-owner+w=401wt.eu-S1030381AbXCCPiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030381AbXCCPiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 10:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030406AbXCCPiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 10:38:54 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:42078 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030381AbXCCPix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 10:38:53 -0500
Message-ID: <45E996A0.6070700@gmail.com>
Date: Sat, 03 Mar 2007 16:39:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/

Weird behaviour of numlock and capslock on USB keyboard in X. After pressing
those keys, keyboard "hangs" -- no sysrq, no lock leds are flashing.

After plug; unplug of the keyboard, it works unless I press the keys
again.

There is nothing in dmesg. X log says
(II) evdev brain: Rescanning devices (3).
(II) evdev brain: Rescanning devices (4).
(II) evdev brain: Rescanning devices (5).
(II) evdev brain: Rescanning devices (6).
(II) evdev brain: Rescanning devices (7).
(II) evdev brain: Rescanning devices (8).
(II) evdev brain: Rescanning devices (9).
(II) evdev brain: Rescanning devices (10).
(II) evdev brain: Rescanning devices (11).
(II) evdev brain: Rescanning devices (12).
(II) evdev brain: Rescanning devices (13).
(II) evdev brain: Rescanning devices (14).
in this kernel, but I don't know if this is relevant.

After booting back to .20-mm2 everything is OK.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null

