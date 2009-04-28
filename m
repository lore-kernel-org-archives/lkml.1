Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbZD1LFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbZD1LFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZD1LEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:04:51 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54014 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZD1LEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:04:50 -0400
Message-ID: <49F6E2BB.9070604@novell.com>
Date: Tue, 28 Apr 2009 07:04:27 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58D75.7040304@redhat.com> <49F5B2DA.5060207@novell.com> <49F6CDFC.6000400@redhat.com> <49F6DB9D.3080501@novell.com> <49F6E1CA.1010106@redhat.com>
In-Reply-To: <49F6E1CA.1010106@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8DF921E6559A6841B11C89C4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8DF921E6559A6841B11C89C4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>
> =20
>
>>> But eventfd_signal basically marries us to eventfd.
>>>    =20
>>
>> Well, only if we expect the fd to have eventfd semantics.  There are
>> advantages to doing so, as we have discussed, because things like AIO
>> can polymorhpically signal an interrupt without even knowing whats
>> behind the eventfd.  But this isn't a strict requirement to support
>> AIO.  Really all we need is a way for both kernel and userspace to
>> signal.  Perhaps I should export an "irqfd_signal()" function from kvm=
,
>> which today will map to eventfd_signal(), and tomorrow to ??.  I don't=

>> think using f_ops->write() is an option for in-kernel signaling, so we=

>> need some kind of interface here.
>>
>> Does that sound reasonable?
>>  =20
>
> irqfd_signal() ties the user of irqfd to kvm.  I want this user to be
> independent of kvm; it should work with eventfd, kvm's eventfd
> lookalike (if we move away from eventfd) or pipes.

So what is your proposal for such interface?

-Greg



--------------enig8DF921E6559A6841B11C89C4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn24rsACgkQlOSOBdgZUxnqrQCfaXg9CHHo5mJd6T3De1te5bhY
Em0An0kOG/hIQy0uH4BK2cuHBglncTm+
=Vy2D
-----END PGP SIGNATURE-----

--------------enig8DF921E6559A6841B11C89C4--
