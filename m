Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYFKOaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYFKOaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYFKOap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:30:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51548 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYFKOao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:30:44 -0400
From: Dan Smith <danms@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] cgroup_clone: use pid of newly created task for new cgroup
References: <20080610212302.GA1946@us.ibm.com>
Date: Wed, 11 Jun 2008 07:30:27 -0700
In-Reply-To: <20080610212302.GA1946@us.ibm.com> (Serge E. Hallyn's message of
	"Tue, 10 Jun 2008 16:23:02 -0500")
Message-ID: <87ve0ggi2k.fsf@caffeine.beaverton.ibm.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

SH> As a result, the new cgroup was created with current's pid.

This works for me and results in the creation of a cgroup named after
the new task's pid instead of the parent's pid.

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

iD8DBQFIT+GFwtEf7b4GJVQRAifMAJ9YTZozv5RLTXrn9g/T1Wb02pD8sgCfW7mP
spo2eU8qEU0/cJhpyxGJIjw=
=HIvH
-----END PGP SIGNATURE-----
--=-=-=--
