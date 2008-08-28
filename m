Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYH1B0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYH1B0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYH1BZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:25:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51639 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbYH1BZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:25:54 -0400
Date: Thu, 28 Aug 2008 11:25:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux-next: Tree for August 27
Message-Id: <20080828112541.7f8f8e0a.sfr@canb.auug.org.au>
In-Reply-To: <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au>
	<200808271206.48370.bzolnier@gmail.com>
	<58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Aug_2008_11_25_41_+1000_wbLrunD8O+I=_K+z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Aug_2008_11_25_41_+1000_wbLrunD8O+I=_K+z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Wed, 27 Aug 2008 16:57:18 +0200 "Bartlomiej Zolnierkiewicz" <bzolnier@gm=
ail.com> wrote:
>
> On Wed, Aug 27, 2008 at 12:06 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> >
> > it fails to build here with:
> >
> > arch/x86/kernel/cpu/addon_cpuid_features.c: In function 'detect_extende=
d_topology':
> > arch/x86/kernel/cpu/addon_cpuid_features.c:119: error: 'struct cpuinfo_=
x86' hasno member named 'cpu_core_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:121: error: 'struct cpuinfo_=
x86' hasno member named 'phys_proc_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:130: error: 'struct cpuinfo_=
x86' hasno member named 'phys_proc_id'
> > arch/x86/kernel/cpu/addon_cpuid_features.c:133: error: 'struct cpuinfo_=
x86' hasno member named 'cpu_core_id'
> > make[2]: *** [arch/x86/kernel/cpu/addon_cpuid_features.o] Error 1
> > make[1]: *** [arch/x86/kernel/cpu] Error 2
> > make: *** [arch/x86/kernel] Error 2
>=20
> which is most likely already fixed in x86 tree by
>=20
> http://lkml.org/lkml/2008/8/27/34

Thanks for finding this, I will apply it to today's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Aug_2008_11_25_41_+1000_wbLrunD8O+I=_K+z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki1/pUACgkQjjKRsyhoI8x0WQCfYFuOImPZPKOuZoQBQpqZO7Gv
7ncAnjz8RsPx8zNdlW2GwT/zx6cYAPe3
=x8bg
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Aug_2008_11_25_41_+1000_wbLrunD8O+I=_K+z--
