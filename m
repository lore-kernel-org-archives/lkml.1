Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbXFGOL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbXFGOL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXFGOLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:11:21 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55443 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbXFGOLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:11:20 -0400
Date: Thu, 7 Jun 2007 16:11:15 +0200 (CEST)
From: Eberhard Moenkeberg <emoenke@gwdg.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Surya <surya.prabhakar@wipro.com>, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk,
       kernel-janitors <kernel-janitors@lists.osdl.org>,
       trivial <trivial@kernel.org>, hannu@opensound.com
Subject: Re: [PATCH]: complete cleanup of check_region
In-Reply-To: <9a8748490706070607oac5b2d4j3098670a0ca6893e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706071609370.28834@gwdu05.gwdg.de>
References: <1181209169.2422.12.camel@bluegenie>  <Pine.LNX.4.64.0706071330500.17273@gwdu05.gwdg.de>
 <9a8748490706070607oac5b2d4j3098670a0ca6893e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1283851528-1137539774-1181225475=:28834"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1283851528-1137539774-1181225475=:28834
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Thu, 7 Jun 2007, Jesper Juhl wrote:
> On 07/06/07, Eberhard Moenkeberg <emoenke@gwdg.de> wrote:
> > On Thu, 7 Jun 2007, Surya wrote:
> > > Hi all,

> > >       This patch cleans up all the instances of check_region and
> > > __check_region and replaces them with request_region and
> > > __request_region. Applies and compiles clean on latest Linus tree.
> > >
> > > Files affected:
> > >       drivers/cdrom/sbpcd.c
> > >       drivers/pnp/resource.c
> > >       include/linux/ioport.h
> > >       kernel/resource.c
> > >       sound/oss/pss.c
> > >
> > >
> > > thanks.
> > >
> > >
> > > Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
> >
> >
> > in drivers/cdrom/sbpcd.c the message string should be changed too.
> >
> > Acked-by: Eberhard Moenkeberg <emoenke@gwdg.de>
> >
>=20
> Huh? I don't understand how you can ACK that patch.
> Are my comments here:  http://lkml.org/lkml/2007/6/7/102  completely
> out in left field?

Yes, my ACK is invalid. It has an earlier time stamp than your clearing=20
mail.


Viele Gr=FC=DFe
Eberhard M=F6nkeberg (emoenke@gwdg.de, em@kki.org)
--1283851528-1137539774-1181225475=:28834--
