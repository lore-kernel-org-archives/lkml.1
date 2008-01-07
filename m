Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYAGM2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYAGM2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYAGM2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:28:21 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:30936 "EHLO
	viefep21-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756894AbYAGM2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:28:20 -0500
Subject: Re: [PATCH 00/11] another rt group sched update
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, dmitry.adamushko@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080107122330.GB25945@linux.vnet.ibm.com>
References: <20080106161128.152634000@chello.nl>
	 <1199703080.7143.24.camel@twins>
	 <20080107122330.GB25945@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UIDUqliFnzg9g/gjuyhZ"
Date: Mon, 07 Jan 2008 13:12:28 +0100
Message-Id: <1199707948.7143.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UIDUqliFnzg9g/gjuyhZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-01-07 at 17:53 +0530, Srivatsa Vaddagiri wrote:
> On Mon, Jan 07, 2008 at 11:51:20AM +0100, Peter Zijlstra wrote:
> >  - figure out what to do for UID based group scheduling, the current
> >    implementation leaves it impossible for !root users to execute
> >    real time tasks by setting rt_runtime_us to 0, and it has no way
> >    to change it.
> >=20
> >    Srivatsa, what happened to the per uid weight patches?, Perhaps we
> >    can extend that interface to allow changing this.
>=20
> Hi Peter,
> 	The sysfs interface for tweaking each user's share should be in
> mainline already (sysfs_create_file() in user_kobject_create()). This
> could be extended for your purpose, hopefully in a straightforward
> manner (you never know that with sysfs :(

Ah, I missed that going in. Thanks, I'll give it a go.

--=-UIDUqliFnzg9g/gjuyhZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHghcsXA2jU0ANEf4RAucNAJ9U0uSlH31nZbQqNu+3sZ4UtT39DwCdHhgB
erSUCe/EtIDZGZ63v2YEZCs=
=Z/3O
-----END PGP SIGNATURE-----

--=-UIDUqliFnzg9g/gjuyhZ--

