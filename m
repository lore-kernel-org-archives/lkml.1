Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZJ1Hsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZJ1Hsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbZJ1Hsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:48:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42864 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbZJ1Hsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:48:53 -0400
Date: Wed, 28 Oct 2009 18:48:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build warning
Message-Id: <20091028184851.504752ef.sfr@canb.auug.org.au>
In-Reply-To: <20091028184126.b5f52d1b.sfr@canb.auug.org.au>
References: <20091028181443.50a09dbb.sfr@canb.auug.org.au>
	<20091028073145.GD6353@elte.hu>
	<20091028184126.b5f52d1b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Oct_2009_18_48_51_+1100_yghw_zaPAgMySmut"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Oct_2009_18_48_51_+1100_yghw_zaPAgMySmut
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 28 Oct 2009 18:41:26 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
> {
>         return physid_mask_of_physid(phys_apicid);
> }

I just noticed that this function (default_apicid_to_cpu_present) is
declared "static inline in a header" but looks like it is only used by
assigning its address to a function pointer.  Its only use for x86_64 is
in arch/x86/kernel/apic/apic_noop.c ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Oct_2009_18_48_51_+1100_yghw_zaPAgMySmut
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrn92MACgkQjjKRsyhoI8yTvQCfaWInS0M1wTxR4OrzyA7oCPTY
LT0An2vO79TWjrbso7EOkJLnBkpssLVn
=UFiw
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Oct_2009_18_48_51_+1100_yghw_zaPAgMySmut--
