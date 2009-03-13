Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbZCMPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbZCMPA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbZCMPAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:00:13 -0400
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:60496 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZCMPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:00:11 -0400
MIME-version: 1.0
Date: Fri, 13 Mar 2009 16:00:00 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: remap_pfn_range() not suitable for physical RAM?
In-reply-to: <7E82351C108FA840AB1866AC776AEC464FD82A88@orsmsx505.amr.corp.intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Message-id: <200903131600.00463.frank.mehnert@sun.com>
Organization: Sun Microsystems
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart2221120.EYVyRzaiG7
Content-transfer-encoding: 7BIT
References: <200903042025.46861.frank.mehnert@sun.com>
 <200903100904.22753.frank.mehnert@sun.com>
 <7E82351C108FA840AB1866AC776AEC464FD82A88@orsmsx505.amr.corp.intel.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2221120.EYVyRzaiG7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Venki,

thanks for your reply. May I ask anyway why this check is done in=20
remap_pfn_range() and vm_insert_pfn() but not in vm_insert_page()?

Kind regards,

=46rank

On Tuesday 10 March 2009, Pallipadi, Venkatesh wrote:
> Frank,
>
> Patch here should eliminate the restriction.
> http://marc.info/?l=3Dlinux-kernel&m=3D123664923030126&w=3D1
>
> Thanks,
> Venki
>
> >-----Original Message-----
> >From: linux-kernel-owner@vger.kernel.org
> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Frank Mehnert
> >Sent: Tuesday, March 10, 2009 1:04 AM
> >To: linux-kernel@vger.kernel.org
> >Cc: peterz@infradead.org; Siddha, Suresh B
> >Subject: Re: remap_pfn_range() not suitable for physical RAM?
> >
> >Hi,
> >
> >sorry for re-posting this message and sorry for addressing you
> >directly.
> >Perhaps you can help me again or can you give me a pointer for a proper
> >documentation of the various *remap* and *vm_insert* functions:
> >
> >On Wednesday 04 March 2009, Frank Mehnert wrote:
> >> since 2.6.29-rcX it seems to be not allowed anymore to use
> >> remap_pfn_range() to remap physical RAM to userland. This restriction
> >> applies only if CONFIG_X86_PAT is enabled. It seems that
> >
> >vm_insert_page()
> >
> >> does not have this restriction. Am I correct? And what is the reason
> >> for this restriction?
> >
> >Kind regards,
> >
> >Frank
> >--
> >Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/
> >--
>
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart2221120.EYVyRzaiG7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm6dPAACgkQ6z8pigLf3Ec1UQCdHNoEgj9xO0HTwKiFScrpaZ6m
4RUAnRSV7U8up5UVFm0dOwa4tfTLHW60
=o85d
-----END PGP SIGNATURE-----

--nextPart2221120.EYVyRzaiG7--
