Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXE3OYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXE3OYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXE3OY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:24:28 -0400
Received: from lucidpixels.com ([75.144.35.66]:45907 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbXE3OY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:24:27 -0400
Date: Wed, 30 May 2007 10:24:26 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Zoltan Boszormenyi <zboszor@dunaweb.hu>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       crmotherboard@mailbox.cps.intel.com
Subject: Case: 225446: Linux 2.6.21.3 does not work with 8GB of RAM on Intel
 965WH
In-Reply-To: <Pine.LNX.4.64.0705300712230.5844@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0705301023541.13945@p34.internal.lan>
References: <465D43C0.60609@dunaweb.hu> <Pine.LNX.4.64.0705300712230.5844@p34.internal.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1554075124-1180535066=:13945"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1554075124-1180535066=:13945
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 30 May 2007, Justin Piszcz wrote:

>
>
> On Wed, 30 May 2007, Zoltan Boszormenyi wrote:
>
>> Hi,
>>=20
>>> Look at how slow the raid benchmarks are in dmesg with 8GB of memory!
>>>=20
>>> [   59.592560] raid6: using algorithm sse2x4 (476 MB/s)
>>> [   59.597558] raid5: using function: generic_sse (56.000 MB/sec)
>>>=20
>>> Yikes!
>>>=20
>>> With mem=3D4096M:
>>> [   60.336352] raid6: using algorithm sse2x4 (6804 MB/s)
>>> [   60.341345] raid5: using function: generic_sse (8552.000 MB/sec)
>>>=20
>>> What is going on here?
>>>=20
>>> Justin.
>>=20
>> I saw a similar effect on a P5 board that could
>> only cache 64MB of memory a long time ago.
>> Putting more memory into it made the machine slower
>> and e.g. made the sym2 driver giving up at initialization.
>> Maybe it's a modern reincarnation of the problem?
>>=20
>> Best regards,
>> Zolt=E1n B=F6sz=F6rm=E9nyi
>>=20
>
> I see, so Intel 965 motherboards do not work with 8GB of memory?  Or is t=
his=20
> a Linux issue?
>
> I have an Intel Case ID open 225446 but so far we have not gotten anywher=
e=20
> with this problem.  Currently I have 8GB in the machine and boot with=20
> mem=3D4096M.  Was there any type of fix?  Any recommendations as to what =
I can=20
> do?  Continue to speak with Intel?  Or perhaps someone with more knowledg=
e of=20
> the kernel and chime in as to what exactly is happening here?
>
> Justin.

Adding Intel to CC list.
---1463747160-1554075124-1180535066=:13945--
