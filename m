Return-Path: <linux-kernel-owner+w=401wt.eu-S964802AbYBGAyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbYBGAyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935208AbYBGAtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:49:42 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:4929 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935197AbYBGAta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:49:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=KvL+44pEBXiekbgtyjwhwHqfvo+6oaHxXaOY9ywYS9dOrFCvPPu9gvBH7fS34tn+II5Ol5/oWrPBusyjHneZBEsfnUVP2Ni8jYkOZSVzAVPylRhprVtrGSLTJxEXMXk9M6GIZDVrROdHNnWR6Uo4FVqejy2VsGZR5+VWdI4KvoQ=
Message-ID: <47AA558F.7030006@gmail.com>
Date: Wed, 06 Feb 2008 19:49:19 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: any cpu hotplug changes in 2.6.24-current-git?
References: <20080206125807.GB26817@elf.ucw.cz> <47A9D14C.8000002@gmail.com> <20080206224441.GC1630@elf.ucw.cz>
In-Reply-To: <20080206224441.GC1630@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8D62710B9CBD0F672C625D09"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8D62710B9CBD0F672C625D09
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Pavel Machek wrote:
> Hi!
>
>  =20
>>> Are there any recent changes in cpu hotplug? I have suspend (random)
>>> problems, nosmp seems to fix it, and last messages in the "it hangs"
>>> case are from cpu hotplug...
>>>      =20
>
>  =20
>>   Can you send along your cpuinfo?
>>    =20
>
> It happened on more than one machine, one cpuinfo is:
>  =20
Ah, ok.  This one is a C2D, correct?  The only reason I asked is that=20
someone was reporting an s2ram problem on P4s on some of that=20
root-domain logic I submitted a little while ago (and was merged in=20
=2E25), whereas C2D seemed fine.  That doesn't mean anything here,=20
really.  The problem could still be my code, or it might be unrelated. =20
I was just wondering if you also had a P4 on the troubled systems.

So is your problem on suspend or resume?  (or both?)  (I know you=20
mentioned it was random problems, but I wasn't sure if you could qualify =

that further)

Any info you can provide will be appreciated.=20

-Greg


> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 14
> model name      : Genuine Intel(R) CPU           T2400  @ 1.83GHz
> stepping        : 8
> cpu MHz         : 1000.000
> cache size      : 2048 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
> bogomips        : 3657.58
> clflush size    : 64
>
> 									Pavel
>  =20



--------------enig8D62710B9CBD0F672C625D09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHqlWUP5K2CMvXmqERArCzAJ4haqg69vel+ufWYLQXvtc1xbzw4ACfWNbV
g6wdalodWYpmhEtcFHOmyQo=
=O+hz
-----END PGP SIGNATURE-----

--------------enig8D62710B9CBD0F672C625D09--
