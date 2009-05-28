Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbZE1Mdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbZE1Mdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbZE1Mdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:33:36 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:57284 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZE1Mdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:33:35 -0400
Date: Thu, 28 May 2009 08:32:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Petr Tesarik <ptesarik@suse.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
In-Reply-To: <1243513274.3170.1.camel@nathan.suse.cz>
Message-ID: <alpine.LFD.2.00.0905280830150.31093@localhost.localdomain>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain> <1243513274.3170.1.camel@nathan.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1177527336-1243513929=:31093"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1177527336-1243513929=:31093
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 28 May 2009, Petr Tesarik wrote:

> Robert P. J. Day p=C3=AD=C5=A1e v =C4=8Ct 23. 04. 2009 v 13:43 -0400:
> > A boolean single_bit_set() routine would simplify the numerous
> > constructs of the form (((n & (n - 1)) =3D=3D 0)) when testing for
> > single-bitness.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > ---
> >
> > This is similar to the current is_power_of_2() routine defined in
> > include/linux/log2.h, which is mathematically identical but,
> > semantically, should be defined independently just so the code is more
> > readable.
> >
> > I'm open to an alternative function name.
>
> ispow2() ?
>
> Because what it really does is to check that a value is a power of two,
> doesn'it.

  by the way, a search for places in the code that are candidates for
this kind of rewriting can be seen at one of my wiki kernel cleanup
pages:

  http://www.crashcourse.ca/wiki/index.php/The_style_script

scroll down, you'll see a section entitled "Testing for power of 2 or
a single bit set".  lots of potential for clarification if people
think it's worth it.

rday
--

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--8323328-1177527336-1243513929=:31093--
