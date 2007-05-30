Return-Path: <linux-kernel-owner+w=401wt.eu-S1752576AbXE3LP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbXE3LP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXE3LPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:15:15 -0400
Received: from lucidpixels.com ([75.144.35.66]:46066 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXE3LPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:15:14 -0400
Date: Wed, 30 May 2007 07:15:12 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Zoltan Boszormenyi <zboszor@dunaweb.hu>
cc: linux-kernel <linux-kernel@vger.kernel.org>, support@mailbox.cps.intel.com
Subject: Re: Kernel 2.6.21.3 does not work with 8GB of RAM on Intel 965WH
In-Reply-To: <465D43C0.60609@dunaweb.hu>
Message-ID: <Pine.LNX.4.64.0705300712230.5844@p34.internal.lan>
References: <465D43C0.60609@dunaweb.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-875916484-1180523712=:5844"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-875916484-1180523712=:5844
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 30 May 2007, Zoltan Boszormenyi wrote:

> Hi,
>
>> Look at how slow the raid benchmarks are in dmesg with 8GB of memory!
>>=20
>> [   59.592560] raid6: using algorithm sse2x4 (476 MB/s)
>> [   59.597558] raid5: using function: generic_sse (56.000 MB/sec)
>>=20
>> Yikes!
>>=20
>> With mem=3D4096M:
>> [   60.336352] raid6: using algorithm sse2x4 (6804 MB/s)
>> [   60.341345] raid5: using function: generic_sse (8552.000 MB/sec)
>>=20
>> What is going on here?
>>=20
>> Justin.
>
> I saw a similar effect on a P5 board that could
> only cache 64MB of memory a long time ago.
> Putting more memory into it made the machine slower
> and e.g. made the sym2 driver giving up at initialization.
> Maybe it's a modern reincarnation of the problem?
>
> Best regards,
> Zolt=E1n B=F6sz=F6rm=E9nyi
>

I see, so Intel 965 motherboards do not work with 8GB of memory?  Or is=20
this a Linux issue?

I have an Intel Case ID open 225446 but so far we have not gotten anywhere=
=20
with this problem.  Currently I have 8GB in the machine and boot with=20
mem=3D4096M.  Was there any type of fix?  Any recommendations as to what I=
=20
can do?  Continue to speak with Intel?  Or perhaps someone with more=20
knowledge of the kernel and chime in as to what exactly is happening here?

Justin.
---1463747160-875916484-1180523712=:5844--
