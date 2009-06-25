Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZFYTZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZFYTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZFYTZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:25:17 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:41023 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZFYTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=NaiU5A+gHLpHDGyft/gBf09WaJnWG656367N5nfIku4ZPEsXtAQu2Ne7tsrXv+d3jC
         3oKI1Z6eWYZ9sBDMRq/WihLfKS5vagM9DjXCT/AEaIVrmftG3Bb+I9YuSfi7BEudLnqi
         MZuz/c3XzVFYXxBaNGJ/OGqX8FkYC5Ut/zsf8=
Message-ID: <4A43CF18.9020908@gmail.com>
Date: Thu, 25 Jun 2009 15:25:12 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: pass value to in_range callback
References: <20090625125333.GB7166@redhat.com> <4A438E8F.4080008@gmail.com> <20090625192329.GB3239@redhat.com>
In-Reply-To: <20090625192329.GB3239@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC2EAB0110F7AFC7CAF5E8D53"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC2EAB0110F7AFC7CAF5E8D53
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 10:49:51AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> For write transactions, pass the value written to in_range checks so
>>> that we can make each iosignalfd a separate device on kvm bus.
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>>
>>> Reposting with a subject now. Sorry.
>>>
>>> Avi, can you please merge this patch in kvm.git so that
>>> Gregory can use it for iosignalfd? Once bus has RCU
>>> we'll be able to remove in_range completely, but
>>> let's do it step by step.
>>>  =20
>>>      =20
>> I think this patch will just make more churn for me, not less.  You ha=
ve
>> now convinced me that your io_range-less approach is better.  ;)
>>
>> Lets just fix the RCU thing and do it right.  Patch is under developme=
nt
>> as we speak.
>>
>> -Greg
>>    =20
>
> So - let's go ahead with this one?
>
>  =20

Whatever you think is best and/or gets us to the end goal the fastest ;)

-Greg


--------------enigC2EAB0110F7AFC7CAF5E8D53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpDzxgACgkQP5K2CMvXmqEBLACfaIjzd+R9D3gaUDX9xczYLxrk
LX0An3Nzt8mt2p6P/IkbN9Up73YxcJ89
=irpY
-----END PGP SIGNATURE-----

--------------enigC2EAB0110F7AFC7CAF5E8D53--
