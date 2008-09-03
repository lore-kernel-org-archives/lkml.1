Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYICNuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYICNuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYICNty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:49:54 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:52222 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbYICNtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:49:53 -0400
Date: Wed, 3 Sep 2008 15:49:51 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Andrey Mirkin <major@openvz.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Message-ID: <20080903134951.GQ14473@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1220439476-16465-1-git-send-email-major@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-23037-1220449658-0001-2"
Content-Disposition: inline
In-Reply-To: <1220439476-16465-1-git-send-email-major@openvz.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-23037-1220449658-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2008 at 02:57:47PM +0400, Andrey Mirkin wrote:
> This patchset introduces kernel based checkpointing/restart as it is
> implemented in OpenVZ project. This patchset has limited functionality and
> are able to checkpoint/restart only single process. Recently Oren Laaden
> sent another kernel based implementation of checkpoint/restart. The main
> differences between this patchset and Oren's patchset are:
>=20
> * In this patchset checkpointing initiated not from the process
> (right now we do not have a container, only namespaces), Oren's patchset
> performs checkpointing from the process context.
>=20
> * Restart in this patchset is initiated from process, which restarts a new
> process (in new namespaces) with saved state. Oren's patchset uses the sa=
me
> process from which restart was initiated and restore saved state over it.
>=20
> * Checkpoint/restart functionality in this patchset is implemented as a k=
ernel
> module
>=20
>=20
> As checkpointing is initiated not from the process which state should be =
saved
> we should freeze a process before saving its state. Right now Container F=
reezer
> from Matt Helsley can be used for this.
>=20
> This patchset introduce only a concept how kernel based checkpointing/res=
tart
> can be implemented and are able to checkpoint/restart only a single proce=
ss
> with simple VMAs.=20
>=20
> I've tried to split my patchset in small patches to make review more easi=
er.

Thank you Andrey for having highlighted the differences with Oren's approac=
h,
and for having split this patchset. Few remarks in reply to the patches.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-23037-1220449658-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIvpX/VKcRuvQ9Q1QRAqf2AJ0VtUg37q4dN4gcTOBJO7Owrq3oKACeLd9g
kW6MglnaunEwEotimKewEwQ=
=38Wz
-----END PGP SIGNATURE-----

--=_bohort-23037-1220449658-0001-2--
