Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbYKXKe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbYKXKe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYKXKeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:34:18 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:45028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYKXKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:34:16 -0500
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Derek Smithies <derek@indranet.co.nz>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, wally@theblackmoor.net
In-Reply-To: <492A7733.2000205@openwrt.org>
References: <492719ED.5000006@gmail.com>
	 <20081122005240.GA27826@hash.localnet>
	 <alpine.DEB.2.00.0811221643030.7067@monster> <4927FC0C.10900@gmail.com>
	 <492A5913.3070007@free.fr>  <492A7733.2000205@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jL3RWv5L57vxZBEb5dgW"
Date: Mon, 24 Nov 2008 11:34:06 +0100
Message-Id: <1227522846.3599.61.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jL3RWv5L57vxZBEb5dgW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 10:43 +0100, Felix Fietkau wrote:
> Benoit PAPILLAULT wrote:
> > I did a similar test here and results is very strange. AP was my good
> > old linksys WRT54G running an iperf server. Client was a laptop running
> > either ath5k or madwifi/trunk and an iperf client. Channel is 5. Both
> > drivers show the same behaviour.
> >=20
> > At the beginning, throughput was very low : 500 - 600 kbit/s. Suddenly
> > (after few minutes), it jumps to 15 - 17 Mbit/s and then few minutes
> > later (let's say 10 - 20 minutes maybe), it jumps back to 500 - 600
> > kbit/s. Using a fixed rate has no effect.
> >=20
> > I used my latest wireless monitoring tools and I did not saw lost of
> > duplicates or lost packets. The only difference was the number of
> > packets sent by seconds....
> >=20
> > Looking a my syslog, I just saw few messages, unrelated in time with th=
e
> > throughput going up or down. They were:
> > - ath5k : unsupported jumbo
> > - switching to short barker preamble
> > - switching to long barker preamble
> >=20
> > I can repeat the same test with iwl3945 as well, if needed.
> While reading the code for calculating the frame duration, i noticed
> something odd: It doesn't seem to be taking into account the short
> vs long preamble distinction for ERP rates. IMHO this might be causing
> issues like this. I've seen similar behaviour a long time ago when testin=
g
> iwl3945 against a Broadcom AP with exactly the same throughput drop (500-
> 600 kbits/s).
> When I analyzed the problem with an extra monitor mode card, I found out
> that the throughput drop is caused by a huge number of retransmissions,
> and if I remember correctly (I didn't look for this specifically back the=
n),
> the retransmissions went down the rate scaling table until they hit the
> first non-ERP rate and that one worked on the first try.
>=20
> Johannes, does that sound like a probable cause? If so, it should be easy
> to fix.

I have no idea. Shouldn't that be easy to tell from the monitor? And if
the short/long switching was _unrelated_ in time it seems like it
wouldn't be a problem?

johannes

--=-jL3RWv5L57vxZBEb5dgW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKoMaAAoJEKVg1VMiehFYSGEQALOd9p4Y+Et73/WcDVfIhy92
SNYQdW90RXdaW1QIKaPVIWhU2uoy2EATx0enyZowPCIr66iX+Z4kzwMACmhKa2yz
AsmujCDFCPzBy7W53ZUBDRnFjtGWOTu/t5YbxvP5lY5rAlXbTa24DP2LlFhAOj5A
GDSeVm/QeRQGn6apugk3tKJt354HO55zl76Iuq5Mdqmu/s09dxRlbAT8bKYKNSms
Qcfd8brnMtIdjCqteR7kkerF98rGcjpkn2g5U3MQSMzEKGdVIlwiYT8QSWVsn5H6
CFySyqiPYm5JfUnO+jMNF/xqYh3o2oDzqxYAv2+FsKJmQAVEhZF3xchWcWb6eyOF
27eSiTtvucCGEpkbWnzjDttLOOsji0UQgS1SsmqFeCarKwaJXQR75HlrzpIwgB8a
2u1BX8siVy6ne8p0PVJZ5MSmbgosMQeLPZmYttMb8NpwUFTkPOzu3ALf4QjamzjQ
lPP4g+3TrXNj/v5SiUXHCPmyx1B8sJTGHZXJDtEPtSo41Jno9osNLnYeufMGwaGt
2rSdHpg6muM5kKWMdzF4y+mGLkLTwDL5ov3tXRtg4uRpPnHPY42C7KgTPrPWjP8N
FYpxex0wF6mPFDgJPzcFxpruuHfWgqfzo6AR/2eWSUpxTx6buevDLCnNasV2zv60
L1LkhRCfGwR/1BNYGq4N
=GqjT
-----END PGP SIGNATURE-----

--=-jL3RWv5L57vxZBEb5dgW--

