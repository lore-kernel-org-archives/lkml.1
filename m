Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZC2Skn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZC2Skn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 14:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZC2Sk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 14:40:28 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:54206 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZC2Sk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 14:40:28 -0400
X-Greylist: delayed 1775 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 14:40:27 EDT
Date: Sun, 29 Mar 2009 13:49:16 +0200
From: Harald Welte <laforge@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
       Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] iptables: "cluster" match uses IPv6-specific code
	without ifdef
Message-ID: <20090329114916.GN15306@prithivi.gnumonks.org>
References: <1238100203-23454-1-git-send-email-steven@uplinklabs.net> <49CC9A32.3060303@netfilter.org> <49CC9C62.7080701@trash.net> <49CCCAF1.7060405@netfilter.org> <49CCCB88.1070104@trash.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kOdvwer/5gjFgNo6"
Content-Disposition: inline
In-Reply-To: <49CCCB88.1070104@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kOdvwer/5gjFgNo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 27, 2009 at 01:50:16PM +0100, Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> Pablo Neira Ayuso wrote:
>>>> Steven Noonan wrote:
>>>>> The symbol __ipv6_addr_type is only available with CONFIG_IPV6 or
>>>>> CONFIG_IPV6_MODULE.
>>>> Please, CC netfilter-devel for netfilter-related issues. Patrick, I'm
>>>> fine with this, can you apply this patch?
>>> Is my reading correct that this won't introduce a module
>>> dependency on IPv6?
>>
>> Hm, this fixes a compilation issue when IPv6 is not enabled. In that
>> case you can still use the cluster match, so I don't see any extra
>> modules dependencies.
>
> That was badly phrased, sorry. The patch of course doesn't change
> anything in that regard.
>
> I'm wondering whether we have a (runtime) dependency on the ipv6
> module due to the ipv6_addr_type() call. If that's the case, it
> would need to be fixed as well.

we don't, see my other mail (linux-next) tree.  It's provided by a function
that is always statically linked into vmlinux.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kOdvwer/5gjFgNo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJz2A8XaXGVTD0i/8RAikQAKCGYhJ9IHL4ih6M9AaMtsDrHVruDgCeK3DW
TqRCivdB1hqf/28Trdb4h84=
=3X+5
-----END PGP SIGNATURE-----

--kOdvwer/5gjFgNo6--
