Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYFBVm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYFBVm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbYFBVmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:42:04 -0400
Received: from gw0.danplanet.com ([71.245.107.82]:55256 "EHLO
	mail.danplanet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752721AbYFBVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:42:01 -0400
X-Greylist: delayed 1473 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2008 17:42:00 EDT
From: Dan Smith <danms@us.ibm.com>
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 00/10] sysfs tagged directories V4
References: <20080602134438.224352910@theryb.frec.bull.fr>
Date: Mon, 02 Jun 2008 14:17:09 -0700
In-Reply-To: <20080602134438.224352910@theryb.frec.bull.fr> (Benjamin Thery's
	message of "Mon, 02 Jun 2008 15:44:38 +0200")
Message-ID: <87ej7filka.fsf@caffeine.beaverton.ibm.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

BT> Here is an updated version of Eric Biederman's patchset to
BT> implement tagged directories in sysfs ported on top of
BT> 2.6.26-rc2-mm1.

With this set applied, I am able to clone() with CLONE_NEWNET, get an
isolated netns, and move interfaces into that namespace.  This removes
the last barrier blocking the implementation of full containers (with
network isolation) in libvirt.

Thanks!

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIRGNXwtEf7b4GJVQRApBdAJsES7txJmV8t49L41p8cfd97y5DFwCeNBSH
p8US3l4RzflflzPp7meade4=
=2/NU
-----END PGP SIGNATURE-----
--=-=-=--
