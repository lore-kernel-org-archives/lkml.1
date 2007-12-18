Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbXLRPdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbXLRPdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbXLRPdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:33:15 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:36213 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbXLRPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:33:14 -0500
Date: Tue, 18 Dec 2007 16:33:02 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: David Newall <david@davidnewall.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Message-ID: <20071218163302.3f54de45@astralstorm.puszkin.org>
In-Reply-To: <47661096.7020107@davidnewall.com>
References: <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
	<47650C88.6040105@davidnewall.com>
	<200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>
	<476512F1.5010701@davidnewall.com>
	<200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
	<200712162114.BJE04102.tOMFHOOFSJVQFL@I-love.SAKURA.ne.jp>
	<47661096.7020107@davidnewall.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+MWAjzo.w_gtxMS2pRC=ZHN";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+MWAjzo.w_gtxMS2pRC=ZHN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Dec 2007 16:30:54 +1030
David Newall <david@davidnewall.com> wrote:

> Tetsuo Handa wrote:
> > If Bob is malicious and creates /dev/sda1 with block-8-2 attribute [...]
>=20
> Bob can't do that.  Only root can.

Not even root can, if you remove him the capability. Only udev can.
(which possibly doesn't have to run as root, given correct capability
set?)

Of course root may be able to change the configuration of udev to
create device nodes of his liking if you allow that...

--Sig_/+MWAjzo.w_gtxMS2pRC=ZHN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHZ+g0BlhXA0ALOYMRAnXvAJ4vn5xjQB6WayfS1Zz1ytnXePuvKQCgjB/n
N/EHRP9zLd13TkVnyZV8sBI=
=sNnv
-----END PGP SIGNATURE-----

--Sig_/+MWAjzo.w_gtxMS2pRC=ZHN--
