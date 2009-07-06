Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZGFSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZGFSsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 14:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZGFSsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 14:48:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:49012 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZGFSsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 14:48:40 -0400
Message-ID: <4A524701.3020808@novell.com>
Date: Mon, 06 Jul 2009 14:48:33 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 0/5] irqfd fixes and enhancements
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <4A4CD729.6050300@redhat.com> <4A50723E.6030305@redhat.com> <4A521082.40209@novell.com> <20090706161331.GB12399@redhat.com> <4A522957.4070901@novell.com> <20090706164955.GE12399@redhat.com>
In-Reply-To: <20090706164955.GE12399@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigED997716173CDEF569319238"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigED997716173CDEF569319238
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jul 06, 2009 at 12:41:59PM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>>>   =20
>>>>        =20
>>> wouldn't it be cleaner to error out in the for each loop if we don't
>>> find an entry to deactivate?  Might be helpful for apps to get an err=
or
>>> if they didn't deassign anything.
>>>  =20
>>>      =20
>> Again, irqfds.init is somewhat orthogonal to whether the list is
>> populated or not.  This check is for sanity (how can you deassign if y=
ou
>> didnt assign, etc).  Normally this would be a simple BUG_ON() sanity
>> check, but I don't want a malicious/broken userspace to gain an easy
>> attack vector ;)
>>    =20
>
> what I'm saying is that deassign should return an error if it's passed
> and entry that is not on the list.

This isn't an unreasonable request, and I believe this is actually the
way the original deassign logic worked before we yanked the feature a
few weeks ago.  Its only slightly complicated by the fact that we may
match multiple irqfds, but I think we solved that before by returning
the number we matched.

If Avi answers the other mail stating he wants to still see the
on-demand work go in, lets use your suggestion.

Regards,
-Greg



--------------enigED997716173CDEF569319238
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpSRwEACgkQlOSOBdgZUxmbxgCcCfH6A6recsiRgMGMTUeToisP
cUgAn1fOV3aQL3VCwA6NRkQlzTCYywv0
=IiGZ
-----END PGP SIGNATURE-----

--------------enigED997716173CDEF569319238--
