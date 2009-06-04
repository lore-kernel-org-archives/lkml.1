Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZFDLxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZFDLxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZFDLxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:53:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:17784 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbZFDLxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=Z8tT0dN0hDik4xJzmJiRd1MFgGqJNrQHwpYw1lEEGtMWyHM7CDUQPUzyUr7YEwbmwr
         jtyH7RzEttlZ5X24qMNny+z1jidn/kzBGoCZ4YJz8IjtRe1ohaUSgcWYB0bKcvlo03/R
         PbgMuNQWhv/Bhev6xsJCm6LNNc5GcvrdaKg2E=
Message-ID: <4A27B597.7090003@gmail.com>
Date: Thu, 04 Jun 2009 07:52:55 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [KVM-RFC PATCH 0/2] irqfd: use POLLHUP notification for close()
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602160434.GA6827@redhat.com> <4A254FD7.5090302@novell.com> <20090602162021.GB6827@redhat.com> <4A255484.6060401@novell.com> <20090602165949.GD6827@redhat.com> <4A256431.2080101@novell.com> <20090603063956.GA8134@redhat.com> <4A27A10C.2050405@redhat.com> <4A27B37F.1060307@gmail.com> <4A27B4F0.9060603@redhat.com>
In-Reply-To: <4A27B4F0.9060603@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB0AB4986039C3D6C731A131"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB0AB4986039C3D6C731A131
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>> I agree that deassign is needed for reasons of symmetry, and that it
>>> can be added later.
>>>
>>>    =20
>> Cool.
>>
>> FYI: Davide's patch has been accepted into -mm (Andrew CC'd).  I am no=
t
>> sure of the protocol here, but I assume this means you can now safely
>> pull it from -mm into kvm.git so the prerequisite for 2/2 is properly
>> met.
>>  =20
>
> I'm not sure either.
>
> But I think I saw a "Thanks for catching that" for 2/2?
>
Ah, right!  I queued that fix up eons ago after David's feedback and
forgot that it was there waiting for me ;)

Since Paul ok'd (I think?) the srcu design, and the only other feedback
was the key-bitmap thing from Davide, I will go ahead and push a v2 with
just that one fix (unless there is any other feedback?)

-Greg


--------------enigEB0AB4986039C3D6C731A131
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkontaIACgkQP5K2CMvXmqEqPQCdE2ioHk0/aNuold2ERChmdQae
HKwAnRSkCFhTg/sbXhOT+VK6vUFySOUn
=Hd4K
-----END PGP SIGNATURE-----

--------------enigEB0AB4986039C3D6C731A131--
