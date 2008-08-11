Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYHKO0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYHKO0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYHKOZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:25:54 -0400
Received: from ms01.sssup.it ([193.205.80.99]:38752 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751181AbYHKOZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:25:53 -0400
X-Greylist: delayed 2172 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2008 10:25:52 EDT
Subject: Re: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
	and groups
From: Dario Faggioli <raistlin@linux.it>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <48A0487B.7080600@redhat.com>
References: <1218462574.6450.24.camel@Palanthas>
	 <48A0487B.7080600@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ig7+p85bztM++qIa2QVD"
Date: Mon, 11 Aug 2008 16:25:48 +0200
Message-Id: <1218464748.6450.34.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ig7+p85bztM++qIa2QVD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-11 at 07:11 -0700, Ulrich Drepper wrote:
> I'm not commenting on the code or usefulness of ht features.  I just
> want to point out a problem.
Ok...

> The authors of that POSIX extension unfortunately decided to extend the
> sched_param structure.  If you look at the definition of that structure
> Linux uses you'll see that there is no place for this.  I.e., any
> implementation of that feature following the POSIX spec to the letter
> will introduce major headache in the form of binary incompatibility.
Yeah, I'm aware of that, as you can see in the comments inside the patch
(has the mail with the patch arrived? It seems no to me :-().

> In case the features is useful enough (I actually always thought it
> isn't an have actually proposed to remove it again from POSIX)
Uao... Thanks for your support! :-P

> then I
> would rather prefer to not claim support for this feature in the POSIX
> way.  One could still implement it as described.  But change the
> interface to not require the sched_param change.
It could be done like this, I agree, for sure.

I would be sorry if we implemented this but we still miss POSIX
support... But I can't imagine any other solution that is not going
cause ABI issues too.

Anyway, thanks a lot for replying.
Dario

--=20
<<This happens because I choose it to happen!>>
(Raistlin Majere, DragonLance Chronicles -Dragons of Spring Drawning-)
----------------------------------------------------------------------
Dario Faggioli
GNU/Linux Registered User: #340657
Web: http://www.linux.it/~raistlin
Blog: http://blog.linux.it/raistlin
SIP Account: dario.faggioli@sipproxy.wengo.fr or
             raistlin@ekiga.net
Jabber Account: dario.faggioli@jabber.org/WengoPhone
GnuPG Key ID: 4DC83AC4
GnuPG Key Fingerprint: 2A78 AD5D B9CF A082 0836 08AD 9385 DA04 4DC8 3AC4

--=-Ig7+p85bztM++qIa2QVD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIoEvsk4XaBE3IOsQRAki+AJ0ZiixplijxtLp1ymnVErB1OCLAbgCfdfgd
+7OWw/q/DWCfccdFYTbK7MA=
=g6gV
-----END PGP SIGNATURE-----

--=-Ig7+p85bztM++qIa2QVD--

