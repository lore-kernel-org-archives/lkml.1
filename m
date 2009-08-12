Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbZHLMlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbZHLMlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZHLMlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:41:36 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:37513 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZHLMlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=smRqwJBa2cY1dIJTSNa+IqAzqCu41Hhs8WqxEjQv4rmM//lDjJpT8AAXPLpLJYnIAh
         9Zpn+7ZpAk+RLi/9v64sCIcJvM0HPHB6LEmPbWU1mGmQNHi3sx8hLn9MQkCP3La5Gsey
         6S9WRAc59vc5nnV9/kRAniJyWPa7i0zYSML+Q=
Message-ID: <4A82B87B.4010208@gmail.com>
Date: Wed, 12 Aug 2009 08:41:31 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org,
       "akpm@linux-foundation.org >> Andrew Morton" 
	<akpm@linux-foundation.org>,
       hpa@zytor.com, Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [PATCHv2 0/2] vhost: a kernel-level virtio server
References: <20090811212743.GA26309@redhat.com> <4A820391.1090404@gmail.com> <20090812071636.GA26847@redhat.com> <4A82ADD5.6040909@gmail.com> <20090812120541.GA29158@redhat.com>
In-Reply-To: <20090812120541.GA29158@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig174E0DB952567894B5C84450"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig174E0DB952567894B5C84450
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Wed, Aug 12, 2009 at 07:56:05AM -0400, Gregory Haskins wrote:
>> Michael S. Tsirkin wrote:

<snip>

>>>
>>> 1. use a dedicated network interface with SRIOV, program mac to match=

>>>    that of guest (for testing, you can set promisc mode, but that is
>>>    bad for performance)
>>
>> Are you saying SRIOV is a requirement, and I can either program the
>> SRIOV adapter with a mac or use promis?  Or are you saying I can use
>> SRIOV+programmed mac OR a regular nic + promisc (with a perf penalty).=

>=20
> SRIOV is not a requirement. And you can also use a dedicated
> nic+programmed mac if you are so inclined.

Makes sense.  Got it.

I was going to add guest-to-guest to the test matrix, but I assume that
is not supported with vhost unless you have something like a VEPA
enabled bridge?

<snip>

>>> 3. add vhost=3DethX
>> You mean via "ip link" I assume?
>=20
> No, that's a new flag for virtio in qemu:
>=20
> -net nic,model=3Dvirtio,vhost=3Dveth0

Ah, ok.  Even better.

Thanks!
-Greg


--------------enig174E0DB952567894B5C84450
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqCuHsACgkQP5K2CMvXmqFbSQCfXtpBd2Q0mrhRjwRuIAyyTt5Y
Ng4An3c7WsysfPVp8bJdLHpPutqgws9L
=2P8B
-----END PGP SIGNATURE-----

--------------enig174E0DB952567894B5C84450--
