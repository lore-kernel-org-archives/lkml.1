Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZIVPlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZIVPlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZIVPlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:41:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39496 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472AbZIVPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:41:49 -0400
Date: Tue, 22 Sep 2009 11:39:51 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] blackfin: Cleanup linker script using new linker script
 	macros.
In-Reply-To: <8bd0f97a0909220830w7435ee32h3ec8f667e2b46d79@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0909221133380.15595@dr-wily.mit.edu>
References: <1252292753-11792-1-git-send-email-tabbott@ksplice.com>  <8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com>  <alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu> <20090916202655.GA17153@merkur.ravnborg.org> 
 <8bd0f97a0909161337v6edbe204wfd83b4c3118b3a27@mail.gmail.com>  <alpine.DEB.1.10.0909221035180.15595@dr-wily.mit.edu> <8bd0f97a0909220830w7435ee32h3ec8f667e2b46d79@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1257051904-982019825-1253633691=:15595"
Content-ID: <alpine.DEB.1.10.0909221139360.15595@dr-wily.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1257051904-982019825-1253633691=:15595
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.1.10.0909221134541.15595@dr-wily.mit.edu>

On Tue, 22 Sep 2009, Mike Frysinger wrote:

> On Tue, Sep 22, 2009 at 11:29, Tim Abbott wrote:
> > On Wed, 16 Sep 2009, Mike Frysinger wrote:
> >> On Wed, Sep 16, 2009 at 16:26, Sam Ravnborg wrote:
> >> > On Wed, Sep 16, 2009 at 11:58:01AM -0400, Tim Abbott wrote:
> >> >> OK. =A0I guess we should plan to modify the INIT_DATA_SECTION macro=
 to add
> >> >> another argument specifying an alignment level for .init.ramfs. =A0=
It'd be
> >> >> inconvenient to add that right now since there are a lot of patches=
 in
> >> >> linux-next or otherwise in flight that introduce uses of
> >> >> INIT_DATA_SECTION, and those patches would all be broken by changin=
g this
> >> >> now. =A0Once the dust settles on that for this release, I'll submit=
 a patch
> >> >> adding said argument to INIT_DATA_SECTION.
> >> >
> >> > But this is all discarded during runtime so the added alignment has =
no cost in the end - no?
> >>
> >> once things are booted, there should be no difference. =A0but
> >> storage/boot costs increase (you have to store/extract/copy that extra
> >> data). =A0you know how miserly we embedded people like to be ;).
> >
> > OK, so how do you want to do this? =A0The options I see are:
> > (1) we merge this patch now, and add the new alignment argument for -rc=
2
> > (2) we add the alignment argument sometime after -rc1 and then merge th=
is
> > for -rc2
>=20
> doing it in two steps is OK by me and sounds like it'd be easier for you

Both options involve two steps -- but as (1) is obviously easier for me, I=
=20
assume that's what you were referring to.  Thanks.

So are you going to send this to Linus?  I'd be happy to do so, but I'd=20
need your ack.

=09-Tim Abbott
---1257051904-982019825-1253633691=:15595--
