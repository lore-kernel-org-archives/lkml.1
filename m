Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXJ1BjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXJ1BjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 21:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXJ1BjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 21:39:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56001 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXJ1BjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 21:39:00 -0400
Date: Sun, 28 Oct 2007 12:38:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [POWERPC] Fix CONFIG_SMP=n build break
Message-Id: <20071028123850.e5b9c555.sfr@canb.auug.org.au>
In-Reply-To: <20071027172851.GA11930@lixom.net>
References: <20071026165510.GA2323@lixom.net>
	<200710262019.12094.arnd@arndb.de>
	<20071027172851.GA11930@lixom.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Oct_2007_12_38_50_+1100_AOw9H7o_ifcB932+"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__28_Oct_2007_12_38_50_+1100_AOw9H7o_ifcB932+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Olof,

Just a trivial thing ...

On Sat, 27 Oct 2007 12:28:51 -0500 Olof Johansson <olof@lixom.net> wrote:
>
> +u8 iic_get_target_id(int cpu)
> +{
> +	return per_cpu(iic, cpu).target_id;
> +}
> +
> +EXPORT_SYMBOL_GPL(iic_get_target_id);

We don't normally put a blank line between a function and its EXPORT...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__28_Oct_2007_12_38_50_+1100_AOw9H7o_ifcB932+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQFHI+gvTgG2atn1QN8RAtViAJMEfDSk9tA6UiVQfyDo3xPKB9C6AJ9rsw63
mcc5TbsvOgB7NjlfXCgvJg==
=+olZ
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Oct_2007_12_38_50_+1100_AOw9H7o_ifcB932+--
