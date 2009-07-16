Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbZGPPcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbZGPPcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbZGPPcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:32:10 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:47392 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbZGPPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type;
        b=jRJO8JFJ3gMLIPT+Dss31vWTwsKIQwH03pseZlrhlndRs8/VcxKER5QIb8qE+cSvun
         7vjiTFm9dbk0q7/Nc9394kg38yGYBRq9fsUWd4h0jKZYwjQVmeQLS6tzpGjY/eZPgGKX
         2qJsFynOyoItwoPkHDc/P9g+dUf6NUNcs28SY=
Message-ID: <4A5F47ED.60209@gmail.com>
Date: Thu, 16 Jul 2009 11:31:57 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, glommer@redhat.com,
       aliguori@us.ibm.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net> <20090716153019.GA5727@merkur.ravnborg.org>
In-Reply-To: <20090716153019.GA5727@merkur.ravnborg.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigACCD667E511732ACDD565264"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigACCD667E511732ACDD565264
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Sam Ravnborg wrote:
>> diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
>> index ad8ec35..9f50cc3 100644
>> --- a/arch/x86/Kbuild
>> +++ b/arch/x86/Kbuild
>> @@ -1,5 +1,7 @@
>> =20
>> -obj-$(CONFIG_KVM) +=3D kvm/
>> +ifdef CONFIG_KVM
>> +obj-y +=3D kvm/
>> +endif
>>    =20
>
> What was wrong with the old version?
> If this is because xinterface.o is builtin to the kernel

Bingo

>  then we should
> always visit kvm/ and use:
>
>    obj-y +=3D kvm/
>
> unconditionally.
>
>  =20
Ok, easy enough.

Thanks Sam,
-Greg




--------------enigACCD667E511732ACDD565264
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpfR/AACgkQP5K2CMvXmqGH/gCghUMzTwAxyjZtYGoJtzd7drYD
ZSkAnjHFnDP8wfaSuzQcB+q5bQtDf7to
=q3nb
-----END PGP SIGNATURE-----

--------------enigACCD667E511732ACDD565264--
