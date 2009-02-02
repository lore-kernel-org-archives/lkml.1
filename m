Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbZBBVmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbZBBVmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759842AbZBBVl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:41:26 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:35461 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759830AbZBBVlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:41:25 -0500
Date: Mon, 2 Feb 2009 19:41:53 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: debian-devel@lists.debian.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: cgroup mount point
Message-ID: <20090202214153.GV3643@vespa.holoscopio.com>
Mail-Followup-To: debian-devel@lists.debian.org,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Content-Disposition: inline
In-Reply-To: <20090202205246.GA28593@glandium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 02, 2009 at 09:52:46PM +0100, Mike Hommey wrote:
> On Mon, Feb 02, 2009 at 09:26:11PM +0100, Julien Cristau wrote:
> > On Mon, 2009-02-02 at 18:00 -0200, Thadeu Lima de Souza Cascardo wrote:
> > > Hello,
> > >=20
> > > Some software I intend to package work with the new cgroup feature in
> > > Linux. I would like to open a discussion about what would be the bett=
er
> > > place to mount it and how/when to mount it.
> >=20
> > What do other distros use?
>=20
> Even better: what do the kernel folks want to do?
>=20
> Mike

=46rom what I've seen, most of them are in the same phases as Debian, or,
perhaps, behind. Fedora seems to plan that for Fedora 11, and they have
some support in libvirt.

Linux Documentation is not consistent and have some funny options. In
Documentation/cgroups/*, we have:

cgroups.txt:
/dev/cgroup

cpuacct.txt:
/cgroups

devices.txt:
/cgroups

memcg_test.txt:
/opt/cgroup
/opt/cpuset
/cgroup

memory.txt:
/cgroups

cpusets.txt:
/dev/cpuset

freezer-subsystem.txt:
/containers

There is also:

Documentation/scheduler/sched-design-CFS.txt:
/dev/cpuctl
/cgroup

Documentation/scheduler/sched-rt-group.txt:
/cgroup

Documentation/accounting/cgroupstats.txt:
/cgroup


So, we have some more options now: /cgroups, /containers, /dev/cpuset,
/dev/cpuctl, /opt/cgroup, /opt/cpuset.

I am copying the container and the kernel guys. Perhaps, we can find an
agreement (if we want to find one at all) and change all that
Documentation to get consistent.

Regards,
Cascardo.

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmHaKEACgkQyTpryRcqtS0sqwCcDigmXRoVTC5Rwq6+O83uHA3O
uP0An0TonymKQRNhtkBM+GxYaIPkHPR0
=VqDr
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
