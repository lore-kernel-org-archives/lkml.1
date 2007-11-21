Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbXKUX7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbXKUX7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 18:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbXKUX7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 18:59:18 -0500
Received: from s2.ukfsn.org ([217.158.120.143]:35868 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbXKUX7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 18:59:17 -0500
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: radeonfb i2c regression post-2.6.18.
References: <1195427766.7022.18.camel@pasglop> <87oddoaqa6.fsf@hardknott.home>
	<1195675089.6970.96.camel@pasglop>
From: Roger Leigh <rleigh@whinlatter.ukfsn.org>
Date: Wed, 21 Nov 2007 23:56:05 +0000
In-Reply-To: <1195675089.6970.96.camel@pasglop> (Benjamin Herrenschmidt's message of "Thu\, 22 Nov 2007 06\:58\:09 +1100")
Message-ID: <877ikbf90q.fsf@hardknott.home>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> > Can you try the patch from Jean that I pasted below and let us know if
>> > it helps ? It looks like the releasing of the i2c lines may have been
>> > done backward.
>>=20
>> This patch fixes the problem.  The monitor stays powered on during the
>> switch to the framebuffer.
>
> Excellent ! That saves me having to test myself :-)
>
> As far as I'm concerned, that's an Ack for the patch.

Fantastic, thanks!  I've copied this to Debian bugs 433236 and 426124
which were about this problem.

BTW, the framebuffer penguin logo looked a little wierd (low number of
colours, odd colours), though on my powerpc it has always looked odd
(wrong colours).  Could there be some endianness bug in the fblogo
code?  I'll check it with other video options when I next have a few
minutes.


Thanks again,
Roger

=2D-=20
  .''`.  Roger Leigh
 : :' :  Debian GNU/Linux             http://people.debian.org/~rleigh/
 `. `'   Printing on GNU/Linux?       http://gutenprint.sourceforge.net/
   `-    GPG Public Key: 0x25BFB848   Please GPG sign your mail.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHRMWYVcFcaSW/uEgRAiSOAJ9NLAFBL4Khjww5/9GGLVM/buEicgCggSi5
/fxd6JzNDG50a+KNyX63Brg=
=W0oL
-----END PGP SIGNATURE-----
--=-=-=--
