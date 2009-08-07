Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZHGSEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZHGSEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZHGSES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:04:18 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:44988 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZHGSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=eIyjPwuib0SlwNx+Qk5BtSYOuC+vSBNoyy+k5tXi33Tn5ayUloHhn8bm16YsSiVL87
         UViW9FuFNEeFsOamHam58OpYB0OWT9iQkvxaUUxwtc85Bd1ueHXJE+Aau4DLdam57/Cb
         DFJKU16l6xmSfDPm8XE0Zr36fR9x/p1Ri7l+I=
Message-ID: <4A7C6C95.7020008@gmail.com>
Date: Fri, 07 Aug 2009 14:04:05 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090806081955.GA9752@redhat.com> <4A7C37E5.4040302@codemonkey.ws> <4A7C42C8.5050608@gmail.com> <4A7C4C50.5040503@codemonkey.ws>
In-Reply-To: <4A7C4C50.5040503@codemonkey.ws>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF78B3F0A78DC3F64F403EF27"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF78B3F0A78DC3F64F403EF27
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Gregory Haskins wrote:
>> That said, note that the graphs were from earlier kernel runs (2.6.28,=

>> 29-rc8).  The most recent data I can find that I published is for
>> 2.6.29, announced with the vbus-v3 release back in April:
>>
>> http://lkml.org/lkml/2009/4/21/408
>>
>> In it, the virtio-net throughput numbers are substantially higher and
>> possibly more in line with your expectations (4.5gb/s) (though notably=

>> still lagging venet, which weighed in at 5.6gb/s).
>>  =20
>=20
> Okay, that makes more sense.  Would be nice to update the graphs as the=
y
> make virtio look really, really bad :-)

Yeah, they are certainly ripe for an update.  (Note that I was
unilaterally stale on venet numbers, too) ;)

>=20
>> Generally, I find that the virtio-net exhibits non-deterministic resul=
ts
>> from release to release.  I suspect (as we have discussed) the
>> tx-mitigation scheme.  Some releases buffer the daylights out of the
>> stream, and virtio gets close(r) throughput (e.g. 4.5g vs 5.8g, but
>> absolutely terrible latency (4000us vs 65us).  Other releases it seems=

>> to operate with more of a compromise (1.3gb/s vs 3.8gb/s, but 350us vs=

>> 85us).
>>  =20
>=20
> Are you using kvm modules or a new kernel?

I just build the entire kernel from git.

> There was some timer
> infrastructure changes around 28/29 and it's possible that the system
> your on is now detecting an hpet which will result in a better time
> source.  That could have an affect on mitigation.

Yeah, I suspect you are right.  I always kept the .config and machine
constant, but I *do* bounce around kernel versions so perhaps I got
hosed by a make-oldconfig cycle somewhere along the way.

>=20
>> If there is another patch-series/tree I should be using for comparison=
,
>> please point me at it.
>>  =20
>=20
> No, I think it's fair to look at upstream Linux.  Looking at the latest=

> bits would be nice though because there are some virtio friendly change=
s
> recently like MSI-x and GRO.

Yeah, I will definitely include kvm.git in addition to whatever is
current from Linus.  I already have adopted using the latest
qemu-kvm.git into my workflow.

Regards,
-Greg


--------------enigF78B3F0A78DC3F64F403EF27
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkp8bJUACgkQP5K2CMvXmqHs+gCfRyYqGSgtnS8hkuH/K4N8SyEA
Ez8Anj/LAO66fxdRYI3elp6czuQYokpf
=m3aa
-----END PGP SIGNATURE-----

--------------enigF78B3F0A78DC3F64F403EF27--
