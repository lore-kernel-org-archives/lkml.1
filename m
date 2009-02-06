Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbZBFWBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbZBFWBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZBFWBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:01:06 -0500
Received: from ns.km10614-05.keymachine.de ([87.118.102.170]:53763 "EHLO
	km10614-05.keymachine.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753972AbZBFWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:01:05 -0500
Date: Fri, 6 Feb 2009 23:00:38 +0100
From: Harald Braumann <harry@unheit.net>
To: =?ISO-8859-1?B?Sm9z6Q==?= Luis =?ISO-8859-1?B?VGFsbPNu?= 
	<jltallon@adv-solutions.net>
Cc: debian-devel@lists.debian.org, linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
Message-ID: <20090206230038.166d4f7f@sbs173>
In-Reply-To: <498B57E9.2020707@adv-solutions.net>
References: <20090202200013.GU3643@vespa.holoscopio.com>
 <1233606371.15779.32.camel@radis.liafa.jussieu.fr>
 <20090202205246.GA28593@glandium.org>
 <20090202214153.GV3643@vespa.holoscopio.com>
 <20090203102416.GA8886@redhat.com>
 <87ljsnzo4v.fsf@benfinney.id.au>
 <1233671913.8902.53.camel@abacate.horta>
 <6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
 <20090203184915.GA10004@glandium.org>
 <20090203185117.GB3359@mini-me.seanius.net>
 <6599ad830902031114t7de1b570p4ed5ec497e2e150e@mail.gmail.com>
 <20090204003847.308cd0df@sbs173>
 <498B57E9.2020707@adv-solutions.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bcfEbR/bi5uv3niIa9R58.n";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bcfEbR/bi5uv3niIa9R58.n
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Feb 2009 22:19:37 +0100
Jos=E9 Luis Tall=F3n <jltallon@adv-solutions.net> wrote:
> [...]
> whereas I can't fathom why a cgroup "feels" like a /device/.
>=20
> I admit not being an expert in virtualization abstraction (I do run a
> significant number of virtual machines, tough), but in fact /sys seems
> to be a much better place for it. Please feel free to argue against if
> my proposal does not in fact make sense.

Agreed. Semantically /sys is probably the place for cgroups.=20

> While it does indeed feel "hackish", mounting a tmpfs on /sys/cgroups
> and then creating as many subdirs as/if necessary is indeed
> achievable, practical and flexible.

Yes, folks have brought forth this technical difficulty and that's why
I initially thought /dev to be a better place.

For me, either would be OK. I don't care that much as long as it's not
mounted in root.

> /proc might be useable though, but it has historically been associated
> with "processes" and the information related to them. And yes, that
> means that /proc/cpuinfo, /proc/meminfo, and /proc/bus would actually
> be out of place there... but keeping backwards compatibility and not
> surprising users is most important.

Agreed. I think the trend is to remove things not related to processes
from /proc. Of course not everything can be removed immediately, but at
least no new things should be added.

Cheers,
harry

--Sig_/bcfEbR/bi5uv3niIa9R58.n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmMswYACgkQwMFqDB+mz26++QCgtLFUAMA1XixyAybIjIP5OWl7
o1IAni+crbmNnZwFSYSSy3ATAUTsXkkV
=vexm
-----END PGP SIGNATURE-----

--Sig_/bcfEbR/bi5uv3niIa9R58.n--
