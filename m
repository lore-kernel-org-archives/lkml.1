Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZAYPFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZAYPFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 10:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZAYPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 10:05:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbZAYPFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 10:05:39 -0500
Date: Sun, 25 Jan 2009 09:04:54 -0600
From: Clark Williams <williams@redhat.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Lee Revell <rlrevell@joe-job.com>,
       linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RT] [RFC] simple SMI detector
Message-ID: <20090125090454.753c05dd@torg>
In-Reply-To: <195c7a900901250349t6c0cdc73gdbd71a9f87151d72@mail.gmail.com>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
	<75b66ecd0901231833j2fda4554sb0f47457ab838566@mail.gmail.com>
	<alpine.LFD.2.00.0901241716540.3424@localhost.localdomain>
	<1232845026.3990.71.camel@perihelion.bos.jonmasters.org>
	<1232849565.29318.112.camel@sven.thebigcorporation.com>
	<20090125040246.GE9216@mit.edu>
	<alpine.LFD.2.00.0901251035050.3424@localhost.localdomain>
	<195c7a900901250349t6c0cdc73gdbd71a9f87151d72@mail.gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0PF5qwM030102

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Sun, 25 Jan 2009 12:49:18 +0100
Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:

> On Sun, Jan 25, 2009 at 10:40 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > My concern about the SMI disable module is that it can damage Joe
> > users hardware. I have at least two reports where the CPU got fried
> > and some others where people got confused because chips started
> > behaving weird and it took quite a time to figure out that they used
> > the SMI disabler. A big fat warning about this code is definitely
> > necessary.
> >
> > Thanks,
> 
> 
> I suppose the non joe user could flash their motherboard with
> linuxcore and therefore do not distrub by SMI :)
> 

Except for the fact that linuxcore is unaware of the specific
requirements a particular motherboard has for thermal management.

Turning off SMI's unconditionally is a *bad* idea. Better to start
telling hardware vendors that we can't use their platform because of
unexplained latencies (which we presume to be SMI's). 

Clark
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkl8f5oACgkQHyuj/+TTEp0JuwCfQaaugU+MY8nWHKsvXuVNmE6X
IEYAoMFn70BK9NczzHI1XnnQwy7bx/Ja
=aRKl
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
