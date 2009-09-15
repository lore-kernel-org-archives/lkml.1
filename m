Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZIOUoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZIOUoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZIOUoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:44:08 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:41879 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZIOUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=caC6byohbpT1GRHliABgpF4u1fzFR8N3/RsFxLb3i15tqphEe9XAHASIxbXWU2d/Xy
         5WpaZsqPfhL1tpntG609f4pyeadPxVufaKDEYlLciWyhG4+Bs0MObOfbGoXqCw/1U1Y4
         yJD8tjhMIWF9ENL0kZ9+GNtuFqeMLaLxF4TbM=
Message-ID: <4AAFFC8E.9010404@gmail.com>
Date: Tue, 15 Sep 2009 16:43:58 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, "Ira W. Snyder" <iws@ovro.caltech.edu>,
       netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
References: <20090913120140.GA31218@redhat.com> <4AAE6A97.7090808@gmail.com> <20090914164750.GB3745@redhat.com> <4AAE961B.6020509@gmail.com> <4AAF8A03.5020806@redhat.com> <4AAF909F.9080306@gmail.com> <4AAF95D1.1080600@redhat.com> <4AAF9BAF.3030109@gmail.com> <4AAFACB5.9050808@redhat.com> <4AAFF437.7060100@gmail.com> <20090915204036.GA27954@redhat.com>
In-Reply-To: <20090915204036.GA27954@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig24896E66E3C399935D536D3E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig24896E66E3C399935D536D3E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Sep 15, 2009 at 04:08:23PM -0400, Gregory Haskins wrote:
>> No, what I mean is how do you surface multiple ethernet and consoles t=
o
>> the guests?  For Ira's case, I think he needs at minimum at least one =
of
>> each, and he mentioned possibly having two unique ethernets at one poi=
nt.
>>
>> His slave boards surface themselves as PCI devices to the x86
>> host.  So how do you use that to make multiple vhost-based devices (sa=
y
>> two virtio-nets, and a virtio-console) communicate across the transpor=
t?
>>
>> There are multiple ways to do this, but what I am saying is that
>> whatever is conceived will start to look eerily like a vbus-connector,=

>> since this is one of its primary purposes ;)
>=20
> Can't all this be in userspace?

Can you outline your proposal?

-Greg


--------------enig24896E66E3C399935D536D3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqv/I4ACgkQP5K2CMvXmqFXNgCeITGEZIQyY1AzJ7od1rh0LGyp
QJcAnAuw/OPdj+0i1gYeklbBHida5NMq
=Fiqk
-----END PGP SIGNATURE-----

--------------enig24896E66E3C399935D536D3E--
