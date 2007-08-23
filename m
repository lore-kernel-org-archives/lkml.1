Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbXHWPm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbXHWPm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762148AbXHWPms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:42:48 -0400
Received: from armagnac.ifi.unizh.ch ([130.60.75.72]:36064 "EHLO
	albatross.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208AbXHWPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:42:47 -0400
Date: Thu, 23 Aug 2007 17:42:44 +0200
From: martin f krafft <madduck@madduck.net>
To: linux-kernel@vger.kernel.org
Subject: Re: what does this mean: "kernel: 7.0.0.1:53 L=79 S=0x00 I=39869
	F=0x4000 T=64"
Message-ID: <20070823154244.GA15919@piper.oerlikon.madduck.net>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070823100045.GA18793@piper.oerlikon.madduck.net> <46CDA81C.4060705@ums.usu.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <46CDA81C.4060705@ums.usu.ru>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux lenny/sid kernel 2.6.22-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Alexander E. Patrakov <patrakov@ums.usu.ru> [2007.08.23.1730 +0=
200]:
>> I am staring at this log message:
>>   kernel: 7.0.0.1:53 L=3D79 S=3D0x00 I=3D39869 F=3D0x4000 T=3D64
>> and I cannot figure out what it's trying to tell me. Could someone
>> please enlighten me?
>
> Looks like some DNS packet got logged by your firewall rules.

But my firewall rules certainly do not log DNS packets, and if they
did, it would look very differently, no? I always prefix my iptables
LOG messages anyway.

This is a Xen client, if it makes a difference.

Now looking at it, it looks as if the log got garbled and 7.0.0.1:53
is really part of 127.0.0.1:53 (the machine does run a recursor).

Can stuff like this happen that data is lost in this way before
syslog can dump it?

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
"convictions are more dangerous enemies of truth than lies."
                                                 - friedrich nietzsche
=20
spamtraps: madduck.bogus@madduck.net

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGzar0IgvIgzMMSnURAkrFAJ9OMb/PpV4J8PmqeGhc1aL9uXr4OgCdGiJK
yVSDsNa12iSWesCM4kojdno=
=saqp
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
