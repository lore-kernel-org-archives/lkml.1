Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZA2QEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZA2QEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZA2QEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:04:09 -0500
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:55735 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZA2QEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:04:08 -0500
Date: Thu, 29 Jan 2009 17:03:35 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: Re: PFs on pages pinned with get_user_pages()
In-reply-to: <1233240757.4495.94.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Message-id: <200901291703.35463.frank.mehnert@sun.com>
Organization: Sun Microsystems
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart8876601.V7GM12iFoE
Content-transfer-encoding: 7BIT
References: <200901290905.10966.frank.mehnert@sun.com>
 <200901291541.32618.frank.mehnert@sun.com> <1233240757.4495.94.camel@laptop>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart8876601.V7GM12iFoE
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 29 January 2009, Peter Zijlstra wrote:
> > > That aside, is there any reason you have to avoid scheduling? Otherwi=
se
> > > I would just allow so and be done with it.
> >
> > The reason is that our code expects that to ensure syncing of the CPU
> > state with the saved state. I fear it is quite difficult to change
> > that...
>
> Ah, is that what KVM uses the preempt notifiers for? Could you too?

Right, that could be an option.

We will try to change our code which is a big effort as we try
to keep the code as unique as possible between the different
hosts we support (Linux, Solaris, Windows, Mac OS X).

Just to be sure: There is no other option than disabling interrupts
or calling disable_preemption() to prevent scheduling?

Kind regards,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart8876601.V7GM12iFoE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmB01cACgkQ6z8pigLf3Eej7wCdGTDgRfXFDvD9M301IUmK4hWF
s3QAmwZrQmXIKp/CKkvcekr5l6Gwi5rD
=YeQM
-----END PGP SIGNATURE-----

--nextPart8876601.V7GM12iFoE--
