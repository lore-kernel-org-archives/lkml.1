Return-Path: <linux-kernel-owner+w=401wt.eu-S934408AbZHENe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbZHENe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934376AbZHENe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:34:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58470 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934359AbZHENe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:34:57 -0400
Date: Wed, 5 Aug 2009 08:32:47 -0500
From: Clark Williams <williams@redhat.com>
To: gowrishankar.m@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
Message-ID: <20090805083247.0b84d1c0@torg>
In-Reply-To: <4A79214B.5070003@linux.vnet.ibm.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	<alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	<alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	<alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	<alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	<alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	<alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	<alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	<alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	<alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	<alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	<alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	<4A79214B.5070003@linux.vnet.ibm.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/K.FiSw7czVnMEWNh9JfQPhd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/K.FiSw7czVnMEWNh9JfQPhd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 05 Aug 2009 11:36:03 +0530
gowrishankar <gowrishankar.m@linux.vnet.ibm.com> wrote:

> Thomas Gleixner wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> >=20
> >     - update to 2.6.31-rc4
>=20
> Hi,
> I am seeing below kernel panic on 8 way Intel and 4 way AMD blades.
>=20
> Kernel panic - not syncing: Attempted to kill init!
> Pid: 1, comm: init Not tainted 2.6.31-rc4-rt1-autotest #1
> Call Trace:
>   [<ffffffff8104c887>] panic+0xc1/0x171
>   [<ffffffff8104ec9a>] ? put_files_struct+0xc3/0xe6
>   [<ffffffff81394313>] ? rt_write_unlock+0x1c/0x32
>   [<ffffffff810582fd>] ? exit_ptrace+0xab/0x130
>   [<ffffffff81394313>] ? rt_write_unlock+0x1c/0x32
>   [<ffffffff810500af>] do_exit+0x88/0x726
>   [<ffffffff810507d5>] do_group_exit+0x88/0xbb
>   [<ffffffff8105082d>] sys_exit_group+0x25/0x3d
>   [<ffffffff8100be2b>] system_call_fastpath+0x16/0x1b
>=20
> Thanks,
> Gowri

Gowri,=20

Would you post your .config so we can see what options you have enabled?

Clark


--Sig_/K.FiSw7czVnMEWNh9JfQPhd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkp5igUACgkQHyuj/+TTEp12yQCgrNoFQSNcBqCzeCCKtzNbO+TY
kZoAnjX1kvSIUsAa/+v+TK9cG00tuENK
=HDuB
-----END PGP SIGNATURE-----

--Sig_/K.FiSw7czVnMEWNh9JfQPhd--
