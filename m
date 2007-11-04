Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbXKDNmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbXKDNmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759443AbXKDNmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:42:06 -0500
Received: from lucidpixels.com ([75.144.35.66]:37033 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852AbXKDNmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:42:04 -0500
Date: Sun, 4 Nov 2007 08:42:04 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
In-Reply-To: <472DCBBB.1040806@systella.fr>
Message-ID: <Pine.LNX.4.64.0711040841160.2225@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <472DCBBB.1040806@systella.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-851533030-1194183724=:2225"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-851533030-1194183724=:2225
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 4 Nov 2007, BERTRAND Jo=EBl wrote:

> Justin Piszcz wrote:
>> # ps auxww | grep D
>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflus=
h]
>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflus=
h]
>>=20
>> After several days/weeks, this is the second time this has happened, whi=
le=20
>> doing regular file I/O (decompressing a file), everything on the device=
=20
>> went into D-state.
>
> =09Same observation here (kernel 2.6.23). I can see this bug when I try=
=20
> to synchronize a raid1 volume over iSCSI (each element is a raid5 volume)=
, or=20
> sometimes only with a 1,5 TB raid5 volume. When this bug occurs, md subsy=
stem=20
> eats 100% of one CPU and pdflush remains in D state too. What is your=20
> architecture ? I use two 32-threads T1000 (sparc64), and I'm trying to=20
> determine if this bug is arch specific.
>
> =09Regards,
>
> =09JKB
>

Using x86_64 here (Q6600/Intel DG965WH).

Justin.
---1463747160-851533030-1194183724=:2225--
