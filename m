Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbZEGSIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbZEGSIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZEGSIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:08:22 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:52815 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZEGSIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=lnCxL9yoSSP0lphI2/5v2rEOBFlcn9Nbp6++x9Ql+VwHZIJROB0l0FztoTBqsOK3QY
         eKpQsdva6jD5Fs4kXEnIho92NITOXY3MeKyFhJEmm9/pGqwsdWNZ8VJ6G8v5L6u7k6cJ
         irWCw4SXa7r6toh610wC8vT5sABZZDZagxu68=
Message-ID: <4A032390.6030100@gmail.com>
Date: Thu, 07 May 2009 14:08:16 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com>
In-Reply-To: <4A0322F1.2000905@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig272D50D3E1F2F5EBA341A444"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig272D50D3E1F2F5EBA341A444
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> I completed the resurrection of the test and wrote up a little wiki on=

>> the subject, which you can find here:
>>
>> http://developer.novell.com/wiki/index.php/WhyHypercalls
>>
>> Hopefully this answers Chris' "show me the numbers" and Anthony's "Why=

>> reinvent the wheel?" questions.
>>
>> I will include this information when I publish the updated v2 series
>> with the s/hypercall/dynhc changes.
>>
>> Let me know if you have any questions.
>>  =20
>
> Well, 420 ns is not to be sneezed at.
>
> What do you think of my mmio hypercall?  That will speed up all mmio
> to be as fast as a hypercall, and then we can use ordinary mmio/pio
> writes to trigger things.
>
I like it!

Bigger question is what kind of work goes into making mmio a pv_op (or
is this already done)?

-Greg


--------------enig272D50D3E1F2F5EBA341A444
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoDI5AACgkQP5K2CMvXmqEtAQCgiix+E5XsSPkq4Q4xlQLpzpHK
iS8AnAhM+RHQKsDJS6ElNsEhFBZEJG5n
=6vsg
-----END PGP SIGNATURE-----

--------------enig272D50D3E1F2F5EBA341A444--
