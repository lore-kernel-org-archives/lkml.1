Return-Path: <linux-kernel-owner+w=401wt.eu-S933822AbXDZJ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbXDZJ3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXDZJ3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:29:04 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:49561 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933805AbXDZJ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:28:44 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020704260117l3794ebe3q7aaa49bc98888d01@mail.gmail.com>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <84144f020704260117l3794ebe3q7aaa49bc98888d01@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uGDdeN97br9L6RTIi/gk"
Date: Thu, 26 Apr 2007 19:28:43 +1000
Message-Id: <1177579723.5025.233.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uGDdeN97br9L6RTIi/gk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 11:17 +0300, Pekka Enberg wrote:
> Hi Nigel,
>=20
> On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> > * Doing things in the right order? (Prepare the image, then do the
> > atomic copy, then save).
>=20
> As I am a total newbie to the power management code, I am unable to
> spot the conceptual difference in uswsusp suspend.c:suspend_system()
> and suspend2 kernel/power/suspend.c:suspend_main(). How are they
> different?

Will discuss in irc since you've appeared there...

> On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> > * Mulithreaded I/O (might as well use multiple cores to compress the
> > image, now that we're hotplugging later).
>=20
> I assume this doesn't affect the kernel at all with uswsusp?

Well uswsusp would benefit from using multiple threads - if it can - to
do the work. I saw quite an improvement from implementing it.

> On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> > * Modular design?
>=20
> This is too broad. Please be more specific of the problems the current
> suspend and snapshot/shutdown code in the kernel has.

Did you see the 'Reasons to merge' email I sent? It has more detail on
this.

> Now to add to your list, as far as I can tell, suspend2 provides
> better feedback to the user via the netlink mechanism (although the
> kernel shouldn't be sending messages such as userui_redraw but instead
> let the userspace know of the actual events, for example, that tasks
> have now been frozen). However, I am unsure if this is still relevant
> as most of the work (snapshot writing) is being done in userspace
> where we explicitly know when processes have been frozen, when the
> snapshot is finished, and when it's written to disk.

=46rom uswsusp's point of view, yeah. But I'm still coming from the 'doing
this in kernelspace makes far more sense' perspective.

Regards,

Nigel

--=-uGDdeN97br9L6RTIi/gk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMHDLN0y+n1M3mo0RAsTCAKCA1+Z8WvUiysKBhMbXNJ84LyiNuACfV9dC
jNUcIOk6KskX1JJk30palKI=
=skmm
-----END PGP SIGNATURE-----

--=-uGDdeN97br9L6RTIi/gk--

