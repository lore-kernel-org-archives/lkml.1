Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbZH1Pbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbZH1Pbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZH1Pbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:31:38 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:35467 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZH1Pbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=JMlS3rTP+NhlCA1myToiLu4KBgwo9xuCPPiJ/Uc/pQ4e9adS7iJbDr8O+VlArTHsQW
         qEOv8BJC/uccigD2Lefd4iDn8Mp2lgLs1rXPV6hQuRf9cA3rF1JsNFoEu3Ri8r/ecSKv
         Ld3CFfkYIslxfOe9TjIGwJrfXbKLlpw8lWgZ0=
Message-ID: <4A97F852.6060505@gmail.com>
Date: Fri, 28 Aug 2009 11:31:30 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, akpm@linux-foundation.org
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com
Subject: Re: [PATCHv5 1/3] mm: export use_mm/unuse_mm to modules
References: <cover.1251388414.git.mst@redhat.com> <20090827160656.GB23722@redhat.com>
In-Reply-To: <20090827160656.GB23722@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1C5BA6B72C76D6CD23C7D55F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1C5BA6B72C76D6CD23C7D55F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> vhost net module wants to do copy to/from user from a kernel thread,
> which needs use_mm (like what fs/aio has).  Move that into mm/ and
> export to modules.


Michael, Andrew,

I am just curious: Is there any technical reason why a kthread cannot
have a long-term use_mm() in effect? (Assuming this makes sense for the
design, of course).  For the cases there we know the kthread will always
service the same context (such as with venettap/vhost, it may make sense
to do a use_mm() at init time and just leave it until the thread exits.
 Will this break anything?

Kind Regards,
-Greg


--------------enig1C5BA6B72C76D6CD23C7D55F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqX+FIACgkQP5K2CMvXmqGsNACghgmvgLjfVfN25itYVCnOSH4G
CIwAn1VdFGYr8TJCQTlY3E1yjibfYjMF
=3B87
-----END PGP SIGNATURE-----

--------------enig1C5BA6B72C76D6CD23C7D55F--
