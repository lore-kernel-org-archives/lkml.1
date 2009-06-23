Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbZFWO4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbZFWO4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbZFWO4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:56:02 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:44857 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366AbZFWO4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=rnjwJWlpl7Oeg7y1GqajdCCQY2L2UagsOW6KNAVruo3LWsBx8EVxDaiL6Fj7bfGl1/
         8z3u2ORk3x+Sf0ahhh3+tJt7wntrsfnoKU97bw3vTKd61ASD60ny6hkChNPBK1GOmUZW
         VO7bG4EAijj8mxzLGsNgSve8N1IEhGdpXQ6C0=
Message-ID: <4A40ECFF.7060706@gmail.com>
Date: Tue, 23 Jun 2009 10:55:59 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org, mingo@elte.hu,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v3 3/3] KVM: Fix races in irqfd using new eventfd_kref_get
 interface
References: <20090622155504.22967.50532.stgit@dev.haskins.net> <20090622160556.22967.76273.stgit@dev.haskins.net> <20090622165708.GB15228@redhat.com> <4A3FBFF1.8050504@gmail.com>
In-Reply-To: <4A3FBFF1.8050504@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEDF22799EF04853ACE249580"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEDF22799EF04853ACE249580
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
>  =20
>
>>  And note that multiple works can run on irqfd
>> in parallel.
>>  =20
>>    =20
>
> They can?  I thought work-queue items were guaranteed to only schedule
> once?  If what you say is true, its broken, I agree, and Ill need to
> revisit.  Let me get back to you.
>  =20

<sigh> Yep, you are right.  This is broken in my code. :(

Will address in the next spin.  Good catch.

-Greg




--------------enigEDF22799EF04853ACE249580
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpA7QAACgkQP5K2CMvXmqGThgCcCXUL9ohvwvOBz+rB1T69Bbhj
8wkAn0i/colSjspjpu0RceNDc08aLYzs
=GSND
-----END PGP SIGNATURE-----

--------------enigEDF22799EF04853ACE249580--
