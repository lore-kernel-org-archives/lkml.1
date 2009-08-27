Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZH0Qdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZH0Qdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZH0Qdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:33:35 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:33440 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbZH0Qde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=m8HCgsQROk76zPYrrtoYv0k8TulbelMJpe9vVkyunJgSFh3S/lH0w8GEmgTFlUgWBV
         dw/cb7iwuzwFiaber3ZSngx6s8F9UgH19+1ILmUTOEqI7bh2E0rnNMR3m7+psDs3hHUz
         cwG9w+9dNmOnc7JUem6KgWxZ9bdwFs+3AG/tc=
Message-ID: <4A96B55C.10001@gmail.com>
Date: Thu, 27 Aug 2009 12:33:32 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: FTRACE: regression in 31-rc7
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF91609C0B60C7ED74F4236C3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF91609C0B60C7ED74F4236C3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Steve,

I just moved from -rc6 to -rc7, and I noticed that the function-graph
tracer suddenly stopped working properly:  I do not see any output from
seeming most things except a handful of interrupt related events.  I
currently believe it may be an issue with tracing modules.

I haven't had a chance to bisect yet, but I did confirm that reverting
the -rc7 merge restores the previous tracer behavior.  Any help/pointers
appreciated.

Kind Regards,
-Greg


--------------enigF91609C0B60C7ED74F4236C3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqWtVwACgkQP5K2CMvXmqERwgCfYPDRTs9YRNbajkxNT/SinZ49
PEoAnRUwddxX+UAH/Evm6ywBjmxBkThH
=Wo6k
-----END PGP SIGNATURE-----

--------------enigF91609C0B60C7ED74F4236C3--
