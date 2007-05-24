Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbXEXLUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbXEXLUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 07:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbXEXLUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 07:20:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:50584 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755911AbXEXLUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 07:20:32 -0400
X-Authenticated: #14603182
X-Provags-ID: V01U2FsdGVkX19gF8hndWdgQ2eCu0K6ijmofXj5UCz7ug9007M4WJ
	Fn14gS6JZ5oitC
Message-ID: <46557500.3070205@gmx.de>
Date: Thu, 24 May 2007 13:20:32 +0200
From: "Lars K.W. Gohlke" <lkwg82@gmx.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc> <4655676A.1000102@gmx.de> <Pine.LNX.4.61.0705241224510.31549@yvahk01.tjqt.qr> <46556CB2.8010709@gmx.de> <Pine.LNX.4.61.0705241246180.31549@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705241246180.31549@yvahk01.tjqt.qr>
Content-Type: multipart/mixed;
 boundary="------------080102050504070500020000"
X-PGP-KeyID: 9D6D68DF
X-Request-PGP: 
X-OpenPGP-Key-ID: 000A26609D6D68DF
X-OpenPGP-Key-Fprint: DA26 DACC EDFB 8E2A 21EC BF11 000A 2660 9D6D 68DF 
X-OpenPGP-Key-URL: 
X-Signed-With-GnuPG: GPGrelay Version 0.959 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--------------080102050504070500020000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jan Engelhardt schrieb:
> On May 24 2007 12:45, Lars K.W. Gohlke wrote:
>
>> Date: Thu, 24 May 2007 12:45:06 +0200
>> From: Lars K.W. Gohlke <lkwg82@gmx.de>
>> To: Jan Engelhardt <jengelh@linux01.gwdg.de>
>> Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
>> Subject: Re: How to access correctly serial port inside module?
>>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Jan Engelhardt schrieb:
>>> On May 24 2007 12:22, Lars K.W. Gohlke wrote:
>>>> ok, I have read everything and also have read the chapters about
>>>> tty_drivers. However I'm not really understand, how to ... .
>>>>
>>>> I will summarize the concrete scenario, which will lead to the
>>>> understanding and further solution of deadling with serial driver.
>>>>
>>>> [scenario]
>>>>
>>>> 1. in userspace I'm doing: > date > /dev/ttyS0
>>>> 2. in kernelspace I want to print out this date.
>>>>
>>>> [/scenario]
>>>>
>>>> I'm really new to kernel coding, that's why I maybe understand some
>>>> functions not the proper way.
>>>>
>>>> I'm a bit confused.
>>> So am I. Usually, you connect two different machines with a serial cable.
>>> (Leaving out the special case of connecting ttyS0-ttyS1 on the same
>>> machine.)
>>>
>>> This poses the first question: whose kernelspace? the sender or
>>> the receiver side? And by "this date" do you perhaps mean
>>> "whatever was sent", or specifically a date? And print to _where_?
>>>
>>> Up to now, it looks like you want to do "cat </dev/ttyS0" in-kernel.
>>>
>>>
>>> Jan
>> date is an example
>>
>> and you got it, I want to do "cat </dev/ttyS0" in-kernel.
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959
>>
>> iD8DBQFGVWy0AAomYJ1taN8RAu7/AJ9+1irJURFy5KFy/wzHqSXXD5sRgACfSi49
>> ec5AnOQoTz2nCt//siaiTNs=
>> =uj4G
>> -----END PGP SIGNATURE-----
>>
>
> 	Jan

for example I want to print out it with printk().

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (MingW32) - GPGrelay v0.959

iD8DBQFGVXUBAAomYJ1taN8RAix3AJ0Q8GTuMg2eJsFbD/fdQFN8SnmoqgCgrHDO
gTj9ygAshefP33OY7a3MGyk=
=Mt6g
-----END PGP SIGNATURE-----

--------------080102050504070500020000
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


--------------080102050504070500020000--

