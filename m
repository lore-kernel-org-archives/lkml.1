Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbZFYTd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbZFYTd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZFYTdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:33:18 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40348 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZFYTdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=gXuD0+XPF8/zGdkbg0ppsyEjAnf+fzohNdZj7x2xERjAlshdE3bFeCBTcPUdBWfXJx
         ndMDfELD+UyLH33wKfxkl/zLj9ii7vdascvWQIxGVFgu5/2qYPn+zjjtplLs6ooq0PPf
         BVH0XTUcwYhaoOtlOy1QmwQcjRi9Nc4187B/c=
Message-ID: <4A43D0FB.2040005@gmail.com>
Date: Thu, 25 Jun 2009 15:33:15 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: pass value to in_range callback
References: <20090625125333.GB7166@redhat.com> <4A438E8F.4080008@gmail.com> <20090625192329.GB3239@redhat.com> <4A43CF18.9020908@gmail.com> <20090625193016.GC3239@redhat.com>
In-Reply-To: <20090625193016.GC3239@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0692539319265305B9E17BF2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0692539319265305B9E17BF2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 25, 2009 at 03:25:12PM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Thu, Jun 25, 2009 at 10:49:51AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> Michael S. Tsirkin wrote:
>>>>    =20
>>>>        =20
>>>>> For write transactions, pass the value written to in_range checks s=
o
>>>>> that we can make each iosignalfd a separate device on kvm bus.
>>>>>
>>>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>>>> ---
>>>>>
>>>>> Reposting with a subject now. Sorry.
>>>>>
>>>>> Avi, can you please merge this patch in kvm.git so that
>>>>> Gregory can use it for iosignalfd? Once bus has RCU
>>>>> we'll be able to remove in_range completely, but
>>>>> let's do it step by step.
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> I think this patch will just make more churn for me, not less.  You =
have
>>>> now convinced me that your io_range-less approach is better.  ;)
>>>>
>>>> Lets just fix the RCU thing and do it right.  Patch is under develop=
ment
>>>> as we speak.
>>>>
>>>> -Greg
>>>>    =20
>>>>        =20
>>> So - let's go ahead with this one?
>>>
>>>  =20
>>>      =20
>> Whatever you think is best and/or gets us to the end goal the fastest =
;)
>>
>> -Greg
>>
>>    =20
>
> It's weekend here. If you can look at rcu meanwhile, go ahead.
> Or I will next week.
>
>  =20
I started looking into it, but it gets kind of messy and is really
conducive to getting rid of in-range at the same time.  So it probably
makes sense to wait until that effort is fully underway.  I'll let you
tackle it and we can sync up later next week.

Thanks, and have a great weekend.
-Greg


--------------enig0692539319265305B9E17BF2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpD0PsACgkQP5K2CMvXmqEt3ACfdgi6Z9hvbpJFAfeM4aWx5AZB
rNIAnjYyPoeyreIKG6P6ViBD8nMcgWxK
=XA0x
-----END PGP SIGNATURE-----

--------------enig0692539319265305B9E17BF2--
