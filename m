Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbYBSMnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbYBSMnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYBSMna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:43:30 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:36691 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbYBSMn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:43:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=LprRr3eHOVYwfQBhsLqlmdGAoK4svA8xo3YjDwtsmDyx/yHVjnqW7TbnOHFXsiBvefEGNddgtq9+dyriBn/WdQMKRdIKFY0LDNuyrN6+cO+6zAQ+YPdaN+wkPHU5KxOPCmYejl3Rs8sprHJhvfB2IpBFgXR94oBrq0ws/I/OmQI=
Message-ID: <47BACEC4.1020906@gmail.com>
Date: Tue, 19 Feb 2008 07:42:44 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] sched: fair-group: per root-domain load	balancing
References: <20080214155724.772744000@chello.nl>	 <20080214160234.681387000@chello.nl>  <47B5C1E1.5090706@gmail.com> <1203104799.6301.16.camel@lappy>
In-Reply-To: <1203104799.6301.16.camel@lappy>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig78BBFB11808A185A0235C87E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig78BBFB11808A185A0235C87E
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Fri, 2008-02-15 at 11:46 -0500, Gregory Haskins wrote:
>  =20
>
>> but perhaps you can convince me that it is not needed?=20
>> (i.e. I am still not understanding how the timer guarantees the stabil=
ity).
>>    =20
>
> ok, let me try again.
>
> So we take rq->lock, at this point we know rd is valid.
> We also know the timer is active.
>
> So when we release it, the last reference can be dropped and we end up
> in the hrtimer_cancel(), right before the kfree().
>
> hrtimer_cancel() will wait for the timer to end. therefore delaying the=

> kfree() until the running timer finished.
>
>  =20

Ok, I see it now.  I agree that I think it is safe.  Thanks!

-Greg


--------------enig78BBFB11808A185A0235C87E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHus7IP5K2CMvXmqERAt/VAJ9tUD4Tp0rKAYlHM8cRd8j/e0rYxACeLEkN
RwnKgrr0HGHqyxBg3VA/oOI=
=ntsc
-----END PGP SIGNATURE-----

--------------enig78BBFB11808A185A0235C87E--
