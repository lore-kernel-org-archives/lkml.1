Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbZIOVjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbZIOVjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZIOVj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:39:29 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:56030 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZIOVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=PNxcz7JSbdrzI36QUbQxlJwM/66FUh6DRAu9Y+kz5WuSZ7W5DA359x7k9JIzXKTIjl
         E2Qi9MCS1B4cabKCQjAtCNvAogyNZS4+AIflWN3pSmNutK/rfHQfgoFWGli2WZ4u3I67
         RdKx+zhwMPoyq+INqAcvVhzzgU+TiRRepUI64=
Message-ID: <4AB0098F.9030207@gmail.com>
Date: Tue, 15 Sep 2009 17:39:27 -0400
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
References: <20090914164750.GB3745@redhat.com> <4AAE961B.6020509@gmail.com> <4AAF8A03.5020806@redhat.com> <4AAF909F.9080306@gmail.com> <4AAF95D1.1080600@redhat.com> <4AAF9BAF.3030109@gmail.com> <4AAFACB5.9050808@redhat.com> <4AAFF437.7060100@gmail.com> <20090915204036.GA27954@redhat.com> <4AAFFC8E.9010404@gmail.com> <20090915212545.GC27954@redhat.com>
In-Reply-To: <20090915212545.GC27954@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE1C8E234A80666A2DFF10887"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE1C8E234A80666A2DFF10887
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Sep 15, 2009 at 04:43:58PM -0400, Gregory Haskins wrote:
>> Michael S. Tsirkin wrote:
>>> On Tue, Sep 15, 2009 at 04:08:23PM -0400, Gregory Haskins wrote:
>>>> No, what I mean is how do you surface multiple ethernet and consoles=
 to
>>>> the guests?  For Ira's case, I think he needs at minimum at least on=
e of
>>>> each, and he mentioned possibly having two unique ethernets at one p=
oint.
>>>>
>>>> His slave boards surface themselves as PCI devices to the x86
>>>> host.  So how do you use that to make multiple vhost-based devices (=
say
>>>> two virtio-nets, and a virtio-console) communicate across the transp=
ort?
>>>>
>>>> There are multiple ways to do this, but what I am saying is that
>>>> whatever is conceived will start to look eerily like a vbus-connecto=
r,
>>>> since this is one of its primary purposes ;)
>>> Can't all this be in userspace?
>> Can you outline your proposal?
>>
>> -Greg
>>
>=20
> Userspace in x86 maps a PCI region, uses it for communication with ppc?=

>=20

And what do you propose this communication to look like?

-Greg


--------------enigE1C8E234A80666A2DFF10887
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqwCY8ACgkQP5K2CMvXmqFo6QCfX2e/9YFa3RtxY3QkALvECB9D
CyoAnRdufMvyfZD3ahmI8vuciuOZXXil
=N7UX
-----END PGP SIGNATURE-----

--------------enigE1C8E234A80666A2DFF10887--
