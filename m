Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZGAMcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZGAMcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZGAMcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:32:11 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:31564
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbZGAMcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:32:10 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 08:32:10 EDT
X-IronPort-AV: E=Sophos;i="4.42,323,1243807200"; 
   d="asc'?scan'208";a="30495911"
Message-ID: <4A4B54D6.8080402@loria.fr>
Date: Wed, 01 Jul 2009 14:21:42 +0200
From: Jens Gustedt <Jens.Gustedt@loria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090608 Lightning/0.9 Thunderbird/2.0.0.22 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: jeremy@jeremyms.com
CC: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by
 encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com>
In-Reply-To: <87hbxx0wcp.fsf@jeremyms.com>
X-Enigmail-Version: 0.95.6
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAACRQTFRF
 ERslNjAsLTE9Ok9wUk9TaUs8iWhSrYZkj42Rz6aD3sGZ/P/7B+vw4wAAAAlwSFlzAAALEwAACxMB
 AJqcGAAAAAd0SU1FB9gGGQk7HLeKUa8AAAIoSURBVDjLhdOxbtswEABQyhmz8BjJ7WjRTVHAk2O3
 S5baUNNm1EB59iAJ6m4R2osgRdfWAv0H0Za6QGPo53onOxYtIOhNgh7IuyOPrH4h2H/hvp5Q/OjC
 djIN5lKKYRcmUxWHACCvOzCNojj0FAh5CpObJM1jpXDRyIZtX+uiREG4sGGcGgydUxpuwdYrCEqd
 KwB23cKfV6aJkoCftzDOzKaqUPL4FN4XL8AnY6oGNGbnZy3c7HBB9YDZk1DwXgtvaKeHpixcsS+r
 gbe4S2UOAGx0hEv8uWlyIPjs3NrqsJfOlzCwwG/K3VD2JW510TbYlgvgOy1c7fsrMYNAGB7hd7ah
 o6KS8A5lrz3d27UKVRpDA34L9S39W6z6OvYQhhasFajsV5TjREhpwU6nOi7WfY15pH9tgdFJataq
 ILBusN6VVNVapQjChtps6HDDiA7rBL5j1wgeTdYJ/DU5TlAISqkOaJUVJQJ0IY+aEwSI4cwqt35a
 RVqv8L+3FGwwsqY9iULsWxHwAd36M3xI869VsQQvBDZgKM/wlOrCJKoBisnxDX7Gh4DpPdgDO77B
 S61x3DzVge3YzbBeFYUHcA4g4V1EE5fgUDscwd1frT8TAWSmLGnae5Ix7u/nCjv7CQucN/xgcoAb
 AcF4Br77zVskCY4bOIHPOCe4ghmI4M5bNOPDe3OB8JHV2xmG/+VOpVgugjsXDnNxxaM7c93g9T0B
 dgHBXPQ4OP8ApiUfmpUgHuIAAAAASUVORK5CYII=
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2B49F2F3C0FB57DCF0D8FFF8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2B49F2F3C0FB57DCF0D8FFF8
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello Jeremy,

> Of course, hibernating to encrypted swap protects against this risk, bu=
t
> having to resort to this effectively limits the usefulness of
> suspend-to-ram.

I don't see how you come to this quick conclusion. If you are only
interested in suspend-to-ram, it is fairly easy set up dmcrypt with a
random key (determined at each boot) for your swap partition. The
performance issues are not noticeable but for extreme swap loads or
intensive parallel applications. In particular on a modern bi-core
processor you will never see a difference.

Such an approach has the advantage of crypting everything that
eventually is written to disk, in particular other privacy relevant
data such as memory used by editors or web browsers.

If you also want to do hibernation, the setup is a bit more complex,
but very much doable for an average linux user nowadays, AFAIKS
support exists in the major distributions. This works equally well
with both hibernation implementations. I use this since several years
now and I am much satisfied with the setup.

Best
Jens

--
:: INRIA Nancy Grand Est :: http://www.loria.fr/~gustedt/ ::
:: Bat B - AlGorille :::::::::::::::::: fon +33 383593090 ::
:: campus scientifique, BP 239 :::::::: gsm +33 688495246 ::
:: 54506 Vand=BDuvre l=E8s Nancy, France :: fax +33 383278319 ::


--------------enig2B49F2F3C0FB57DCF0D8FFF8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpLVNYACgkQD9PoadrVN+K+4wCeOQ4uqk1QZZi2tmQq0EBaPS7p
27EAn1WT69oKPh8YsTUo7SnIqDAFLleL
=BZM5
-----END PGP SIGNATURE-----

--------------enig2B49F2F3C0FB57DCF0D8FFF8--

