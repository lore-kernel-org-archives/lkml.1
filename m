Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZFRSsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZFRSsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZFRSsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:48:30 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38122 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZFRSsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:48:30 -0400
Message-ID: <4A3A8BF0.4020907@novell.com>
Date: Thu, 18 Jun 2009 14:48:16 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, mst@redhat.com, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [KVM PATCH 3/4] eventfd: add generalized notifier interface
References: <20090618173534.24119.95115.stgit@dev.haskins.net> <20090618174426.24119.69689.stgit@dev.haskins.net> <alpine.DEB.1.10.0906181044160.32646@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906181044160.32646@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE9C91C8052F31087C27D572B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE9C91C8052F31087C27D572B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Thu, 18 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> We currently open-code notification registration via the f_ops->poll()=

>> method of the eventfd.  Lets abstract this into a notification API
>> extension of eventfd, while still using the wait-queue as the underlyi=
ng
>> mechanism.  This will allow us to manage the notification mechanism
>> internal to eventfd without requiring the clients to change.  This als=
o
>> gives us the opportunity to implement race-free release() callbacks,
>> which we do later in the series.
>>    =20
>
> Another attempt to push KVM stuff into eventfd.

Also, could you please detail how you expect someone to use the POLLHUP
release in a race free way without patches 3/4 + 4/4?  That is not a KVM
specific problem either, afaict.

-Greg



--------------enigE9C91C8052F31087C27D572B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko6i/AACgkQlOSOBdgZUxmi2QCgjpuklaETO6r9iE/CVp7Ku+lE
K+kAn1N8/mabpP6ok2J4oCnSqM/g51TQ
=p2N4
-----END PGP SIGNATURE-----

--------------enigE9C91C8052F31087C27D572B--
