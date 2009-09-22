Return-Path: <linux-kernel-owner+w=401wt.eu-S1751716AbZIVTCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbZIVTCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZIVTCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:02:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZIVTB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:01:59 -0400
Date: Tue, 22 Sep 2009 14:01:13 -0500
From: Clark Williams <williams@redhat.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31-rt11
Message-ID: <20090922140113.689e8e03@torg>
In-Reply-To: <4AB91817.1050108@us.ibm.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	<alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	<alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	<alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	<alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	<alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
	<alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
	<alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	<alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
	<alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
	<alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
	<alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
	<4AB91817.1050108@us.ibm.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d3a95fFWsxtssfChSrx5fmT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d3a95fFWsxtssfChSrx5fmT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Sep 2009 11:31:51 -0700
Darren Hart <dvhltc@us.ibm.com> wrote:

> Thomas Gleixner wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> >=20
> >    - latencytop fix
> >=20
> >    - disable SPARSE_IRQ, DMAR, IRQ_REMAP for -rt
> >=20
> > Known issues:
> >    - ARM highmem
> >    - scheduler load balancing oddities. Peter is working on it.
> >    - timer_interrupt hang check (still working on somthing useful)
> >=20
> > The planned "add back MIPS support" is postponed to rt12.
> >=20
> > Download locations:
> >=20
> >     http://rt.et.redhat.com/download/
> >     http://www.kernel.org/pub/linux/kernel/projects/rt/
> >=20
> > Git release branch:
> >     git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git=
 rt/2.6.31
> >  =20
> > Git development branch:
> >     git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git=
 rt/head
> >=20
> > Gitweb:
> >     http://git.kernel.org/?p=3Dlinux/kernel/git/tip/linux-2.6-tip.git;a=
=3Dshortlog;h=3Drt/2.6.31
> >=20
> > Information on the RT patch can be found at:
> >=20
> >     http://rt.wiki.kernel.org/index.php/Main_Page
> >=20
> > to build the 2.6.31-rt11 tree, the following patches should be
> > applied:
> >=20
> >     http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.31.tar.bz2
> >     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31-rt1=
1.bz2
> >=20
> > Enjoy !
> >=20
> >       tglx
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rt-user=
s" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Hitting a repeating BUG at boot on my Thinkpad T60p:
>=20
> [    2.861699] BUG: sleeping function called from invalid context at=20
> kernel/rtmutex.c:684
> [    2.861839] in_atomic(): 1, irqs_disabled(): 0, pid: 777, name: sleep
> [    2.861967] Pid: 777, comm: sleep Not tainted 2.6.31-rc4-rt1-dvh01 #1
> [    2.862092] Call Trace:
> [    2.862217]  [<c012d881>] __might_sleep+0xe1/0x100
> [    2.862343]  [<c056ccba>] rt_spin_lock+0x2a/0x70
> [    2.862468]  [<c018243a>] res_counter_uncharge+0x2a/0x50
> [    2.862593]  [<c01e6e23>] __mem_cgroup_uncharge_common+0x93/0x190
> [    2.862720]  [<c01e6fb8>] mem_cgroup_uncharge_page+0x28/0x30
> [    2.862845]  [<c01d6b87>] page_remove_rmap+0x47/0x50
> [    2.862969]  [<c01cf2d9>] unmap_vmas+0x349/0x6b0
> [    2.863093]  [<c01d45e5>] exit_mmap+0xc5/0x1c0
> [    2.863217]  [<c0140481>] mmput+0x51/0xc0
> [    2.863339]  [<c0146465>] exit_mm+0x105/0x140
> [    2.863462]  [<c01465b5>] do_exit+0x115/0x760
> [    2.863584]  [<c0146cc4>] sys_exit+0x14/0x20
> [    2.863707]  [<c0103025>] syscall_call+0x7/0xb
>=20
> I'm looking for a problem with preempt_disable() between LinuxCon=20
> seesions now.  But if someone already knows the problem, thought I'd post.
>=20
> Thanks,

I saw that (or something very similar) on my T60 a couple of versions
back but thought it got fixed. Send me your .config, will you?

Clark

--Sig_/d3a95fFWsxtssfChSrx5fmT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkq5Hv0ACgkQHyuj/+TTEp0C3gCeIM+E8DQMbJaDMr7nZ4t5vqHJ
M9kAn2Dn83NDG6ER4IodEtVxWk9OybLU
=+1LN
-----END PGP SIGNATURE-----

--Sig_/d3a95fFWsxtssfChSrx5fmT--
