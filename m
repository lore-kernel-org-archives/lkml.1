Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZFVNUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZFVNUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZFVNUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:20:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:28815 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZFVNUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=w0zgf4UDv8zmPIJus9KaYt9VhuAoGeMd7WvzwDgr+iDBEXohJiEGbLBIqXvlKNBYD0
         juyBqITxTyAbHuYCO0PbQvVIi1nawlATg7dmWV1b/yFvdKKmSmnb6WJxJTpidl/E5s8e
         KX0sUrTcpGjrsur/vO9Eg6sfpsZ0/XPtoD6Ss=
Message-ID: <4A3F84FD.3090700@gmail.com>
Date: Mon, 22 Jun 2009 09:19:57 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 3/3] KVM: add iosignalfd support
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622104435.GA11594@redhat.com> <4A3F757C.6030508@novell.com> <20090622123022.GC12867@redhat.com> <4A3F8170.7000508@gmail.com> <20090622131351.GE12867@redhat.com>
In-Reply-To: <20090622131351.GE12867@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9831ACCC4F115803D27E67A4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9831ACCC4F115803D27E67A4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jun 22, 2009 at 09:04:48AM -0400, Gregory Haskins wrote:
>  =20
>> Sorry, Michael.  I missed that you had other comments after the
>> grammatical one.  Will answer inline
>>
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Mon, Jun 22, 2009 at 08:13:48AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>
>>>> If thats true, we are in trouble ;)
>>>>    =20
>>>>        =20
>>> I think it works at least on x86:
>>> http://en.wikipedia.org/wiki/Packed#x86_and_x86-64
>>>  =20
>>>      =20
>> Right, understood.  What I meant specifically is that if the (void*)va=
l
>> pointer is allowed to be misaligned we are in trouble ;).  I haven't
>> studied the implementation in front of the MMIO callback recently, but=
 I
>> generally doubt thats the case.  More than likely this is some buffer
>> that was kmalloced and that should already be aligned to the machine w=
ord.
>>
>> Kind Regards,
>> -Greg
>>
>>    =20
>
> Yes, from what I saw of the code I think it can be BUG_ON.
> Avi?
>
>  =20

The question to ask is whether a guest can influence that condition.  If
they can, its an attack vector to crash the host.  I suspect they can't,
however.  Therefore, your recommendation is perhaps a good approach so
this condition cannot ever go unnoticed.  Avi?

-Greg


--------------enig9831ACCC4F115803D27E67A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/hP0ACgkQP5K2CMvXmqEOjACfV/cMVIAUoycWu1N0+0aS440N
7JcAnA2p/4jmgY9HWnK/SFVYvNBYEbag
=Rv2O
-----END PGP SIGNATURE-----

--------------enig9831ACCC4F115803D27E67A4--
