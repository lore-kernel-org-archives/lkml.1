Return-Path: <linux-kernel-owner+w=401wt.eu-S1764516AbXK3SoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764516AbXK3SoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762813AbXK3Sni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:43:38 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22163 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761724AbXK3Snh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:43:37 -0500
Message-ID: <475059D6.2080900@msgid.tls.msk.ru>
Date: Fri, 30 Nov 2007 21:43:34 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: 2.6.23: does it supposed to work on an i486?
References: <47504923.9030309@msgid.tls.msk.ru> <4750519C.2000907@zytor.com>
In-Reply-To: <4750519C.2000907@zytor.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Michael Tokarev wrote:
[2.6.23 on an i486 machine]
>> The result is immediately machine reboot right
>> after bootloader (etherboot) passes control to
>> the kernel -- BEFORE "Uncompressing linux"
>> message.
>>
>> 2.6.22 worked just fine.
[]
> It looks like 2.6.23.9 is missing checkin
> 7ed192906a2144ebc8ca2925a85d27b9c5355668 from Linus' tree (attached),
> which is necessary to work on 386 and 486.

Well, I applied the patch (in 2.6.23 it's
 arch/i386/boot/pmjump.S,
not
 arch/x86/boot/pmjump.S,
but that's minor) - still the same behavior, it still reboots
instantly right when bootloader gave control to the kernel.
So it must be something else.. ;)

I'll try other kernels tomorrow, given some time (I already
spent almost the whole day today with this "machine").  This
whole story prompted me to just throw those machines away and
replace them with tiny devices (a small print server in this
case).  There are still several 486-class machines out there...

By the way, this very machine I'm experimenting with is a
strange beast by itself.  For example, etherboot does not
work on it properly, anything since version 5.1.0 just
freezes right after displaying the "greeting" message.
5.0.11 works.  However till now, linux worked on it just
fine, -- unlike etherboot.

Thanks!

/mjt
