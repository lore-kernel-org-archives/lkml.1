Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZEUOEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZEUOEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbZEUOEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:04:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44506 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbZEUOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:04:33 -0400
Message-ID: <4A155F68.6010402@novell.com>
Date: Thu, 21 May 2009 10:04:24 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, kvm@vger.kernel.org
Subject: Re: [PATCH v2] kvm: fix irqfd build failure discovered in linux-next
References: <20090521172122.bb12027c.sfr@canb.auug.org.au> <20090521132817.8218.92948.stgit@dev.haskins.net> <4A155C86.7010604@redhat.com>
In-Reply-To: <4A155C86.7010604@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF5A67133507691F654F093A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF5A67133507691F654F093A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> Stephen Rothwell noted a build failure in arch !=3D x86 in last nights=

>> linux-next tree, as noted here:
>>
>> http://lkml.org/lkml/2009/5/21/32
>>
>> This patch corrects the build issue by requiring explicit support for
>> IRQFD to be defined, and only defining it on x86 (the only arch fully
>> supported).  The code itself isnt architecture dependent, but we need
>> to add a new file to each makefile, advertise the capability, and
>> of course, test that it works for each supported arch.  We will submit=

>> patches against each relevant arch at a later time to enable support
>> there as well.
>>
>> =20
>> +config HAVE_KVM_EVENTFD
>> +       bool
>> +       default y
>> +
>>  =20
>
> The build system will complain if it sees a symbol used but not
> defined; so you have to define it for all four archs.  So I went ahead
> and did virt/kvm/Kconfig and adapted your patch to use it.
>
>

Cool, thanks!

-Greg


--------------enigBF5A67133507691F654F093A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoVX2wACgkQlOSOBdgZUxnq1ACbBMqtYGlBiMMLZnVg19u7zHKE
tkwAn0Yt5JHHiUAsSQHKfP3b0AeGVKdK
=2FOG
-----END PGP SIGNATURE-----

--------------enigBF5A67133507691F654F093A--
