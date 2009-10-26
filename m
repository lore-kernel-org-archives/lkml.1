Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZJZIRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZJZIRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZJZIR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:17:29 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:54901 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZJZIR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:17:29 -0400
Message-ID: <4AE55B1B.2030006@web.de>
Date: Mon, 26 Oct 2009 09:17:31 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
 on 	top of perf events
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>	 <1256393818-8921-5-git-send-email-fweisbec@gmail.com>	 <4AE32926.2020005@web.de> <c62985530910251631v4c0ccf7ak91b376c97666001b@mail.gmail.com>
In-Reply-To: <c62985530910251631v4c0ccf7ak91b376c97666001b@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBBC2351D5BF09A9D6315C1F1"
X-Provags-ID: V01U2FsdGVkX19ukrKPFb2LhGxCM7ueWin3H8KsCNjmdHp7O2nf
	tqBuVSwJspdaQazVJfEKKr9jvmQlcF5jNKmFGj39Vvo5W9mthr
	kNZ3XQu1E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBBC2351D5BF09A9D6315C1F1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Frederic Weisbecker wrote:
> 2009/10/24 Jan Kiszka <jan.kiszka@web.de>:
>> Since commit 3d53c27d05, KVM uses current->thread.debugregs for
>> restoring the host state in case the guest played with breakpoints. We=

>> need an equivalent interface to restore ptrace breakpoints and all
>> others currently in use.
>>
>> Jan
>=20
>=20
> Well, dr6 is still stored in the current thread.
> dr7 has a per cpu variable containing its value.
>=20
> So what remains is to have a per cpu variable for dr0-3
> which is updated when perf schedules in/out a profiled context.
> I can do that in a v3.

Sounds great. Maybe you can stuff all this into some function kvm can
call to avoid that it has to peek into various internal structures.

Jan


--------------enigBBC2351D5BF09A9D6315C1F1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkrlWxsACgkQitSsb3rl5xTZ5ACfXSj1XFMDDwlMr6ETfkZzZBuz
ayEAoOY3ptfU4V0+M5+wY9PyG6SnaWGl
=6FPU
-----END PGP SIGNATURE-----

--------------enigBBC2351D5BF09A9D6315C1F1--
