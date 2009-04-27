Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZD0NVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZD0NVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbZD0NUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:20:54 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:48403 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZD0NUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gTjGbude2nThWZMjnaeFwmCTIaAX6wP00P36GrqxlSKIoeHUaMorN/jETrkG6HLA8u
         sW3kTVtUrNA4p5u5cGStYecuxHqnTRgA+wf5HLjYQNPSjMPkQpwfo9H/t10/5IbwrVGO
         o5jYrErqHKMvvMAUyeEkb/JttZ06vfUhSh1F8=
Date: Mon, 27 Apr 2009 08:20:43 -0500
From: Michael E Brown <mebrown@michaels-house.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: Class device namespaces
Message-ID: <20090427132041.GA18391@sc1430.michaels-house.net>
References: <20090329174836.6de797d6@hyperion.delvare> <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> <20090330104952.26f03c13@hyperion.delvare> <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com> <20090426085401.3788fc9c@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20090426085401.3788fc9c@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 26, 2009 at 08:54:01AM +0200, Jean Delvare wrote:
> Hi Kay,
>=20
> Sorry, completely overlooked your reply... Ah, now I remember, I was
> waiting for Michael to show up and comment on this. Michael, ping? As
> long as we don't know the exact requirements and constraints of the
> dell firmware tool, we're somewhat stuck.
>=20
> Matt, maybe you can help? Could you please point us to the source code
> of the dell firmware tool which relies on the dell_rbu driver?

Sorry about that. Skimmed the thread and looks like I missed out...

The problem is that there are two users: 1) libsmbios as Matt has
already mentioned, and 2) Dell OpenMange Server Administrator.
Specifically srvadmin-hapi has the code to use the dell_rbu code
(proprietary, no source available). The srvadmin-hapi code is embedded
into all Dell Update Packages (DUPs).

The problem being that any change to the paths breaks all released DUPs.
--
Michael

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn1sSkACgkQcnW8GdAFD+VLgACfaPfvSfNBLC83WcGdz2O54E+h
72wAoOqth+WGWekw8xz5v4ZTZJrV2jtQ
=62xH
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
