Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZGAMAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZGAMAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZGAL76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:59:58 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54596 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZGAL75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:59:57 -0400
Message-ID: <4A4B4FAD.7010004@novell.com>
Date: Wed, 01 Jul 2009 07:59:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCHv5 0/6] kvm: locking and API rework for iosignalfd
References: <20090629192358.GA27464@redhat.com> <4A4B1A13.3060809@redhat.com>
In-Reply-To: <4A4B1A13.3060809@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig629D3DB6F0693D39EBC46797"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig629D3DB6F0693D39EBC46797
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 06/29/2009 10:23 PM, Michael S. Tsirkin wrote:
>> This series switches kvm_io_device to slots_lock from kvm->lock mutex,=

>> and uses that to rework io bus API. This takes less locks on data path=
,
>> and uses less lines of code. These changes will also be useful to serv=
e
>> as basis for Greg's iosignalfd work.
>>   =20
>
> Applied all, thanks.
>
I'll get to work rebasing iosignalfd now.  Thanks guys!

-Greg


--------------enig629D3DB6F0693D39EBC46797
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpLT7EACgkQlOSOBdgZUxnuUgCeMkFDvIrqqJrQlrqQMs7k4BXH
jPQAnRRjkkZO7prS7ilM6sSaveULMm9W
=quRc
-----END PGP SIGNATURE-----

--------------enig629D3DB6F0693D39EBC46797--
