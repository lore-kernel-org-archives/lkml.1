Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXEXRUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXEXRUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXEXRT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:19:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:59476 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751047AbXEXRT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:19:57 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX19Bv4VHlsJBI76Wv0A5DBLzFU34SsRSj/m5xV6tPX
	WDp0MYq65M3VFz
Message-ID: <4655C93D.40005@gmx.de>
Date: Thu, 24 May 2007 19:19:57 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc> <4655676A.1000102@gmx.de> <4655C554.7030000@imap.cc>
In-Reply-To: <4655C554.7030000@imap.cc>
Content-Type: multipart/mixed;
 boundary="------------020704050900070602000709"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------020704050900070602000709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tilman Schmidt schrieb:
> Am 24.05.2007 12:22 schrieb Lars K.W. Gohlke:
>> I will summarize the concrete scenario, which will lead to the
>> understanding and further solution of deadling with serial driver.
>>
>> [scenario]
>>
>> 	1. in userspace I'm doing: > date > /dev/ttyS0
>> 	2. in kernelspace I want to print out this date.
>>
>> [/scenario]
>
> I must admit that now I do not understand anything anymore.
> I thought you wanted to receive some data over an RS232 serial
> port and process it in your kernel module, but this doesn't
> look like that at all.
>


> So what is it you are trying to do?
> Do you just want to write something to a file in userspace and
> receive it in your kernel module?
I want to read from serial port (I mean the port, which is called
/dev/ttyS0 in user-space). Then I want copy_to_user() it through
/proc/serialPort

This is just to get familiar with driver programming (in kernelspace),
it could be better done in userspace - I know. But this is for learning.

It is a kind of synthetic problem, but after this, I hope too know how
to handle further ones.

Understood? It is a little bit strange, but hope it is explained well. ;)

If tell me that for /dev/ttyS0 I can adept it to /dev/ttyS1 etc..

thx

>
> Regards,
> Tilman
>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGVck/AAomYJ1taN8RAiYwAJ96kYK6byxHea5MhvO0zaEB1yAXQQCdGS9c
PFU39kx+d/xgj9QxusfEplc=
=OeRZ
-----END PGP SIGNATURE-----

--------------020704050900070602000709
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


--------------020704050900070602000709--

