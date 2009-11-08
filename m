Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZKHTiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZKHTiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZKHTiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:38:24 -0500
Received: from mail.sdinet.de ([78.47.32.153]:37296 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbZKHTiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:38:23 -0500
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Nov 2009 14:38:23 EST
Date: Sun, 8 Nov 2009 20:29:55 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Matteo Croce <technoboy85@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
In-Reply-To: <20091108181016.GB32364@elf.ucw.cz>
Message-ID: <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
 <20091108173708.GF1372@ucw.cz> <40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com> <20091108181016.GB32364@elf.ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-409339750-1257708600=:30789"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-409339750-1257708600=:30789
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 8 Nov 2009, Pavel Machek wrote:

> On Sun 2009-11-08 18:40:06, Matteo Croce wrote:
> > On Sun, Nov 8, 2009 at 6:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > > On Fri 2009-11-06 23:18:06, Matteo Croce wrote:
> > >> On Fri, Nov 6, 2009 at 5:44 PM, H. Peter Anvin <hpa@zytor.com> wrote=
:
> > >> > On 11/06/2009 06:59 AM, Matteo Croce wrote:
> > >> >> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instr=
uction (NOPL).
> > >> >
> > >> > MMX and MMXEXT are hardly hallmarks of i686, which leaves only cmo=
v.
> > >> > I'm somewhat wondering about the general value of this patch; is i=
686
> > >> > code really that much faster on Geode that it's worth it?
> > >> >
> > >> > ? ? ? ?-hpa
> > >> >
> > >> > --
> > >> > H. Peter Anvin, Intel Open Source Technology Center
> > >> > I work for Intel. ?I don't speak on their behalf.
> > >> >
> > >> >
> > >>
> > >> yes, I did some test like gzip, bzip2, lame etc and they give more o=
r less
> > >> the same results of dhrystone
> > >>
> > >> root@alix:/usr/src# CFLAGS=3D'-march=3Di586' ./dry.c
> > >> Microseconds for one run through Dhrystone: =A0 =A0 =A0 =A01.4
> > >> Dhrystones per Second: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0740741
> > > ...
> > >> root@alix:/usr/src# CFLAGS=3D'-march=3Di686' ./dry.c
> > >> Trying 5000000 runs through Dhrystone:
> > >> Microseconds for one run through Dhrystone: =A0 =A0 =A0 =A01.2
> > >> Dhrystones per Second: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0841751
> > >
> > > Teach gcc that geodelx exists? No need to break kernel for that... an=
d
> > > you probably can gain even bigger gains.

But no standard distribution will be made available in a geode special=20
version - not enough machines in the marekt. So I think it is better to=20
be able to use the i686 specific things they already support, like=20
libc6-686 from debian for example.

c'ya
sven

--=20
The lights are fading out, once more...
--8323328-409339750-1257708600=:30789--
