Return-Path: <linux-kernel-owner+w=401wt.eu-S1030540AbXBFXLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030540AbXBFXLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030557AbXBFXLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:11:47 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48243 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030556AbXBFXLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:11:45 -0500
X-Sasl-enc: tRtstthYAE4t1/alxuV3Ljrp4z1ukBZXxkJeZ7ZTxU8G 1170803501
Message-ID: <45C90B57.90104@imap.cc>
Date: Wed, 07 Feb 2007 00:12:23 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, netdev@vger.kernel.org,
       netfilter-devel@lists.netfilter.org
Subject: Re: dynticks + iptables almost stops the boot process [was: Re: 2.6.20-rc6-mm3]
References: <20070131215241.GB2890@inferi.kami.home> <20070131232130.GC4137@inferi.kami.home> <1170358572.29240.292.camel@localhost.localdomain> <1170360101.29240.297.camel@localhost.localdomain> <20070201211137.GA2830@inferi.kami.home> <1170369202.29240.339.camel@localhost.localdomain> <20070202191802.GA4262@inferi.kami.home> <1170448034.29240.364.camel@localhost.localdomain> <20070202204344.GB4262@inferi.kami.home> <20070206164826.GA3491@elte.hu> <20070206192840.GB2971@inferi.kami.home>
In-Reply-To: <20070206192840.GB2971@inferi.kami.home>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig078781D7F46D04E8339CF8CB"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig078781D7F46D04E8339CF8CB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 06.02.2007 20:28 schrieb Mattia Dongili:
> On Tue, Feb 06, 2007 at 05:48:26PM +0100, Ingo Molnar wrote:
>> Could you try the patch below? The RCU serialization code (a rare call=
=20
>> but can be common in some types of setups) has a nasty implicit=20
>> dependency on the HZ tick - which until now was a hidden wart but beca=
me=20
>> an explicit bug under dynticks. Maybe this is what is slowing down you=
r=20
>> box.

I have the same problem (huge delay when loading iptables) with
2.6.20-rc6-mm3, and for me this patch did fix it.

> No, not this. Anyway the last patch Thomas forwarded does fix the
> problem.

Which one would that be? I might try it for comparison.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig078781D7F46D04E8339CF8CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFyQtfMdB4Whm86/kRAh1SAJ4nD7AUYhg1gU7UloR588LGaO0L+wCeO2un
CImLLx8g+vh7yfduSEgwfXU=
=YkNg
-----END PGP SIGNATURE-----

--------------enig078781D7F46D04E8339CF8CB--
