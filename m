Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbZGPTsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbZGPTsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933164AbZGPTse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:48:34 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:12467 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132AbZGPTsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=NRxxdBB8gKlsUrC30Is3gO4dZKvT4JAqgtXR3Zb5TS2iObdSuX8WYNxYlbiigC8iog
         Lid0+oo9KUXdaNNLCw1+0zPnpUGFDNgcZjlxWUSrW7dazk/W/nBxfkRtQMcL2Ut8cHRD
         9ccYoLVWBdF0endkqC2y88KEAB3LYRxjJhUUk=
Message-ID: <4A5F8404.1040408@gmail.com>
Date: Thu, 16 Jul 2009 15:48:20 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Gregory Haskins <ghaskins@novell.com>, Arnd Bergmann <arnd@arndb.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       glommer@redhat.com, aliguori@us.ibm.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net> <200907161852.42071.arnd@arndb.de> <4A5F6FF4.2090706@novell.com> <4A5F773C.2020303@novell.com> <4A5F81BF.5000301@acm.org>
In-Reply-To: <4A5F81BF.5000301@acm.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig014880A7936364E9D5EE3287"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig014880A7936364E9D5EE3287
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Zan Lynx wrote:
> Gregory Haskins wrote:
>> Gregory Haskins wrote:
>>> Note that if we are going to generalize the interface to support othe=
r
>>> guests as you may have been suggesting above, it should probably stay=

>>> statically linked (and perhaps live in ./lib or something)
>>>  =20
>>
>> More specifically, it can no longer live in kvm.ko.  I guess it
>> technically doesn't have to be statically linked, though (e.g.
>> xinterface.ko is fine, too).
>
> Speaking as someone who knows nothing about this, if this is going to
> be a module and visible in places like lsmod, could you name it
> something else?
>
> I see "xinterface.ko" and the first thing in my head is "something to
> do with the X Window System."
>
> How about kvm_xinterface or vguest_xinterface?
>

Heh, I totally agree.  That was just pseudo-naming, anyway. ;)

If it was going to be generic, I would do something like
"virt-xinterface.ko".

Kind Regards,
-Greg


--------------enig014880A7936364E9D5EE3287
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpfhAgACgkQP5K2CMvXmqH3AwCeNydw8IcEBskULI0oI1tCpP6d
uYoAnR+sqTmBvx0GfrjIuL513Q5M7UZd
=Lf6I
-----END PGP SIGNATURE-----

--------------enig014880A7936364E9D5EE3287--
