Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbXIWVQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbXIWVQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 17:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXIWVPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 17:15:53 -0400
Received: from barikada.upol.cz ([158.194.242.200]:50255 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbXIWVPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 17:15:53 -0400
To: Mihai Dontu <mihai.dontu@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23-rc7 + radeonfb/s2ram
In-Reply-To: <200709232222.29066.mihai.dontu@gmail.com>
References: <200709220828.00078.mihai.dontu@gmail.com> <200709232131.02348.mihai.dontu@gmail.com> <200709232118.09884.rjw@sisk.pl> <200709232222.29066.mihai.dontu@gmail.com>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sun, 23 Sep 2007 23:31:33 +0200
Message-Id: <E1IZZ37-0001OI-8g@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sun, 23 Sep 2007 22:22:28 +0300
* Organization: Home

[]
>> > 
>> >   So there, if one wants "ATI Radeon display support" on Radeon XPRESS 200M with
>> >   X using radeon_drv.so, *should* put "Framebuffer Console support" to N (if it's
>> >   not already).
[]
>   Bottom line: no radeonfb for me :( at least, not now; but I have to be honest with
>   you: I don't see what commit dd1447134454b169d5ae353aceb93f2368db8547 brought new
>   into the picture. The previous radeonfb worked just great, but then, again, maybe I'm
>   not using the console at it's full power :)

In fact, it's known statement, that there must only one hardware driver
for graphic adapter. Be it framebuffer with X fb driver on it or legacy
VGA text and X with its driver.so and 3D stuff.

(i choose legacy text without X for the most of my time, though :)
_____
