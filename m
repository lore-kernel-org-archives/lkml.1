Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZKWLGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZKWLGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbZKWLGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:06:13 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:32908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbZKWLGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:06:12 -0500
Subject: kvmmmu tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: kvm <kvm@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tbLn8ffqNyzL03QrjVRl"
Date: Mon, 23 Nov 2009 12:06:15 +0100
Message-ID: <1258974375.7094.158.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tbLn8ffqNyzL03QrjVRl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit f691fe1da7e2715137d21ae5a80bec64db4625db is really broken wrt.
the userspace interface for tracing because of the weird
KVM_MMU_PAGE_PRINTK macro.

Maybe we should have a "unsafe for export" flag for events, if they do
strange things like that?

As it stands, I can't use trace-cmd on an x86 machine that has kvm
enabled because it will try to read all the kvm stuff. Arguably, it
should only try to parse it when it needs it (i.e. not for me) but still
it's very inconvenient to export something to userspace that it cannot
possibly understand.

johannes

--=-tbLn8ffqNyzL03QrjVRl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCmyhAAoJEODzc/N7+QmaYZsP/j9LORSwWM+8MlKbmz9fdiTB
AcV7FwodAlX7ffY3ZyzvDOjRfFsQq28bFy8/9eDG4YcZTQt075Fo9ZOj5fN9gnJe
C+7/AbH8vVzxMW2mh4JgMfSviBlaOl+vycOyS4Xqa2x/k8Cosl00Omti+XrVh3+P
FZzEeXYBtT2GMZFigkpwm4DNGhjqyH4iVW9ZbKTpV6chC3rw57eP78z6V9oYP8nj
kiVghulrhsZfdG3NW+0WmxdiFNOKi3RNRIwKjYtYhe5ymY6a6fzF+85IszUrB1gb
lwLYDOzjueb/lJ7g1Whvbkz6kSccFMCeONVnxzP/xrCFzZfbwnB44YeS83UeMt80
PHnXBYX96aaKxo8w+ppDml1cVDguDkrDYNnfh+K3nDTzFYFcrnoIO8io4rrJ/wKe
hKGxi+zEqmdEIEH/h5zJ1DFUKwRaM/yRtVGYAUkb6fNOKwlyuK2Gy1Gujp2Bc96I
dbuOaSC/z3rjyeXotnt+0tKKja/SUCMVTMz9PFEdbY9kymPS4jGHCVKqdgACN9jn
CBbCcIJYmANldxWSMg5UVVs84OOTCPeWs3qCc+hAQj7EKQZzH0EjEo6OKZLwOMca
VKCHy5EZ4omCHsGXCscmHgGGoECpXkOheepZL3b7epT2H38uUBvMUjeoUZanrXPL
UX95Sv9iDkGO/2Ewl+l6
=qzkY
-----END PGP SIGNATURE-----

--=-tbLn8ffqNyzL03QrjVRl--

