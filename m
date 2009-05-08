Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZEHOQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZEHOQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZEHOPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:15:54 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58763 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZEHOPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:15:53 -0400
Message-ID: <4A043E89.90403@novell.com>
Date: Fri, 08 May 2009 10:15:37 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet>
In-Reply-To: <20090507233503.GA9103@amt.cnet>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2AE78BB1D74339238338E4A4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2AE78BB1D74339238338E4A4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Marcelo Tosatti wrote:
> On Thu, May 07, 2009 at 01:03:45PM -0400, Gregory Haskins wrote:
>  =20
>> Chris Wright wrote:
>>    =20
>>> * Gregory Haskins (ghaskins@novell.com) wrote:
>>>  =20
>>>      =20
>>>> Chris Wright wrote:
>>>>    =20
>>>>        =20
>>>>> VF drivers can also have this issue (and typically use mmio).
>>>>> I at least have a better idea what your proposal is, thanks for
>>>>> explanation.  Are you able to demonstrate concrete benefit with it =
yet
>>>>> (improved latency numbers for example)?
>>>>>      =20
>>>>>          =20
>>>> I had a test-harness/numbers for this kind of thing, but its a bit
>>>> crufty since its from ~1.5 years ago.  I will dig it up, update it, =
and
>>>> generate/post new numbers.
>>>>    =20
>>>>        =20
>>> That would be useful, because I keep coming back to pio and shared
>>> page(s) when think of why not to do this.  Seems I'm not alone in tha=
t.
>>>
>>> thanks,
>>> -chris
>>>  =20
>>>      =20
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
>>    =20
>
> Greg,
>
> I think comparison is not entirely fair.

<snip>

FYI: I've update the test/wiki to (hopefully) address your concerns.

http://developer.novell.com/wiki/index.php/WhyHypercalls

Regards,
-Greg



--------------enig2AE78BB1D74339238338E4A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoEPokACgkQlOSOBdgZUxkyaACeLJs4ACwZc9smJhpBfOjn720/
QuAAnjguH+2sRz0cmcCjQRinkinGxXI+
=MsJy
-----END PGP SIGNATURE-----

--------------enig2AE78BB1D74339238338E4A4--
