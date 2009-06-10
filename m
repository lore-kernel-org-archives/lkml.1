Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZFJSpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZFJSpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbZFJSpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:45:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57183 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbZFJSpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:45:00 -0400
Date: Wed, 10 Jun 2009 14:45:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Frysinger <vapier.adi@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
In-Reply-To: <8bd0f97a0906101131m2fc21f75uc174631150897e5e@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0906101441410.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org>  <1244623722-6325-2-git-send-email-vapier@gentoo.org> <alpine.DEB.2.00.0906101303560.30552@gandalf.stny.rr.com> <8bd0f97a0906101131m2fc21f75uc174631150897e5e@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1029764566-1244659502=:30552"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1029764566-1244659502=:30552
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Wed, 10 Jun 2009, Mike Frysinger wrote:

> On Wed, Jun 10, 2009 at 13:04, Steven Rostedt wrote:
> > On Wed, 10 Jun 2009, Mike Frysinger wrote:
> >> While implementing ftracer and ftracer graph support, I found the exac=
t
> >> arch implementation details to be a bit lacking (and my x86 foo ain't
> >> great). =C2=A0So after pounding out support for the Blackfin arch, doc=
ument
> >> the requirements.
> >
> > This does not belong in the Kconfig. That's the last place a developer
> > will look for implementing something.
>=20
> yes and no -- i was following the existing documenting practice of
> ftrace where details were added to the Kconfig.  guess i should fix
> that in the process.

Documenting what should be selected and why is one thing, but to document=
=20
implementation is another. I'm not against documentation in Kconfig, but=20
that should explain more about why things are selected. But not=20
implementation details.


>=20
> there should be at least tips in each HAVE_XXX as to where to look for
> implementation details.

That can be opening a can of worms.

Really, the focus of the documentation in Kconfig is about why things must=
=20
be selected, not how to implement the code to add that selection.

If there's a HAVE_XXX in Kconfig that I want to see how to implement it, I=
=20
go off and do 'grep -r XXX Documentation'.

-- Steve

--8323328-1029764566-1244659502=:30552--
