Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbXEXKXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbXEXKXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbXEXKW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:22:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:32838 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754478AbXEXKW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:22:57 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX19v+TB5QB9vIbzkEGU14rB57YOIZpPFfs32MJMbDO
	K3UkqR4HKtxeIt
Message-ID: <4655676A.1000102@gmx.de>
Date: Thu, 24 May 2007 12:22:34 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc>
In-Reply-To: <46536C0F.50101@imap.cc>
Content-Type: multipart/mixed;
 boundary="------------050205090000090106050706"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------050205090000090106050706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tilman Schmidt schrieb:
> Am 15.05.2007 10:43 schrieb Jan Engelhardt:
>> On May 15 2007 01:00, Tilman Schmidt wrote:
>>> Am 14.05.2007 22:00 schrieb Jan Engelhardt:
>>>> On May 14 2007 19:40, Lars K.W. Gohlke wrote:
>>>>>> after searching the mailing list and searching the web, I still don't
>>>>>> know how to access correctly the serial port (in user space known as
>>>>>> /dev/ttyS01)
>>>> http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad
>>> That's not nice, sending a newbie on a wild goose chase like that.
>>> He doesn't want to write to a file from kernel after all. Reading
>>> FAQs is never bad, of course, but reading that particular one
>>> won't help him at all with this questions.
>> The original poster is quite unclear about how he wants to access the
>> serial port. [...]
>> Unfortunately, my magic sphere is out of order, so I could only take
>> a really really vague guess at what was wanted.
>
> He asked about "the correct way". The document you cited will just
> warn him against one of the many incorrect ones. That's less helpful
> than not answering at all.
>
>>>> inb/inw/inl, printk, outb/outw/outl.
>>> This is even less nice. You're sending him down the road of
>>> directly programming UART registers, knowing full well (I hope)
>>> that this a Bad Thing.
>> This is how 8250.c works.
>
> Exactly. Which is one reason why other parts of the kernel should not
> do it themselves. (Another being of course that if you do it that way,
> your code will only work with that particular type of serial port
> hardware. As the last of the Ten Commandments for C Programmers has
> been declaring for ages, you shouldn't assume that "All the world's a
> VAX^WPC.")
>
> HTH
> T.
>

ok, I have read everything and also have read the chapters about
tty_drivers. However I'm not really understand, how to ... .

I will summarize the concrete scenario, which will lead to the
understanding and further solution of deadling with serial driver.

[scenario]

	1. in userspace I'm doing: > date > /dev/ttyS0
	2. in kernelspace I want to print out this date.

[/scenario]

I'm really new to kernel coding, that's why I maybe understand some
functions not the proper way.

I'm a bit confused.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGVWeCAAomYJ1taN8RAjaAAJ476KjYne485RBVnwA3/h+FMFz+HgCgkE6w
FK4mahSRx8L4+Lo/hNKQWks=
=Cozv
-----END PGP SIGNATURE-----

--------------050205090000090106050706
Content-Type: text/x-vcard; charset=utf-8;
 name="lkwg82.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lkwg82.vcf"

begin:vcard
fn:Lars K.W. Gohlke
n:Gohlke;Lars K.W.
email;internet:lkwg82@gmx.de
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------050205090000090106050706--

