Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYK1Lmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYK1Lmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYK1Lm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:42:29 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:3219 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYK1Lm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:42:28 -0500
Message-ID: <492FD864.50901@imap.cc>
Date: Fri, 28 Nov 2008 12:39:16 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.18) Gecko/20081031 SeaMonkey/1.1.13 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@linux.it>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] ldisc: new dcd_change() method for line disciplines.
References: <> <1227647470-4816-1-git-send-email-giometti@linux.it> <1227647470-4816-2-git-send-email-giometti@linux.it>
In-Reply-To: <1227647470-4816-2-git-send-email-giometti@linux.it>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB4ABB402498B73E57F90B470"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB4ABB402498B73E57F90B470
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Rodolfo Giometti schrieb:
> --- a/include/linux/tty_ldisc.h
> +++ b/include/linux/tty_ldisc.h
> @@ -99,11 +99,19 @@
>   *	cease I/O to the tty driver. Can sleep. The driver should
>   *	seek to perform this action quickly but should wait until
>   *	any pending driver I/O is completed.
> + *
> + * void (*dcd_change)(struct uart_port *port, unsigned int status,
> + * 			struct timespec *ts)
> + *
> + *	Tells the discipline that the DCD pin has changed its status and
> + *	the relative timestamp. Pointer ts can be NULL.
>   */

I don't see an actual call to that new method getting added anywhere.
Is that planned for a later patch? Which serial drivers will support
that mechanism? Should the documentation perhaps mention that not
all drivers support this?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB4ABB402498B73E57F90B470
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJL9hsQ3+did9BuFsRAju9AJ9loGZQNYSkgUQlb8psri968Fm6owCdG2/A
zJEMcABUjrBgdBpg1jcSWq0=
=F7Dv
-----END PGP SIGNATURE-----

--------------enigB4ABB402498B73E57F90B470--
